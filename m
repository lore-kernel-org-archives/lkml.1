Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYHVCFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYHVCFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYHVCFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:05:05 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:35941 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751611AbYHVCFE (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:05:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tLUS7VLkjZK0iAYMM86gUeONjtoldl2j2v54MZrFsCZwkJ0iuRWpCPccD71PGsBvsMZfjJk16R/rMQBTTT8oXO32K7KOh6Js2M2zwStIx0ANHPtoKZJ6o1y4k7xmvKhKse/aDfQqE9+1AmmbeL7T/RwzZ+di9gqcxgB5hFotgZk=  ;
X-YMail-OSG: uaS5cgQVM1mqCT59UGF1mlGOqpBFVwOPUMmnzgqJCIHh2AelINm7DzEmFeOB2iioG.IX5SBCqFQUU7cI0MDzgWN8W1EHJ39yUrX039Nc2yKTzOxMTa5ilw3GIe9u9FuKIdI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Fri, 22 Aug 2008 12:04:57 +1000
User-Agent: KMail/1.9.5
Cc: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com
References: <48AD00C4.6060302@gmail.com> <ac9c93b10808202332n2654884eh877848df2da59f20@mail.gmail.com> <6934efce0808211232i21fcf347vb6baa6502246adb2@mail.gmail.com>
In-Reply-To: <6934efce0808211232i21fcf347vb6baa6502246adb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221204.57413.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 05:32, Jared Hulbert wrote:
> > Jared, nice work!

> > - would axfs be suitable as a filesystem on a ram disk?
>
> It could be.  I plan on implementing support for brd.  That might work
> nicely.

I was going to take a look at this too. With any luck, it should be
little effort required as it looks like you have the block device
support in place?

This filesystem actually should in theory work fairly well with brd,
because then we wouldn't have to bring the data over into pagecache
for frequently used pages but we can retain the compressed storage
for the infrequently used stuff.

I say in theory because I don't know of any serious users (except
kernel testing) of brd :)
