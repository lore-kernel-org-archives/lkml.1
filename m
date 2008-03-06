Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbYCFLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbYCFLEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764491AbYCFK5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:57:35 -0500
Received: from n38.bullet.mail.ukl.yahoo.com ([87.248.110.171]:34823 "HELO
	n38.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763795AbYCFK5e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:57:34 -0500
X-Yahoo-Newman-Id: 671881.43509.bm@omp417.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GFzTTr9Q2yBhhROX/SQJddiBzfmXHf9yv1xJicxmZF4FKPTbms8eGPCcGSv8IBHZl99N0vhDpEXgwRS1HsAww13grMH1dybGd9Y76r7xwHsBWN4yp/ef748PnnBTjTDVQzYYCpqS2tw9czAjx1b1LUEXDowZbPd0tvosCwSpobU=  ;
X-YMail-OSG: EMAQ1sgVM1nWPtWqFXE3HjCm.N20rYTBu8zj6qqLmEUbx2p2Xc3334ptK5SgoqwlixR7CoWjiw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of the disk image
Date: Thu, 6 Mar 2008 21:56:58 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net> <200803062057.50181.nickpiggin@yahoo.com.au> <1204798585.4325.8.camel@frecb07144>
In-Reply-To: <1204798585.4325.8.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803062156.58230.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 21:16, Laurent Vivier wrote:
> Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :

> > Do you think we do something similar for drivers/block/brd.c too? I'd
> > like to try to maintain parity between them where possible...
>
> I think it is possible  (I've the same patch for NBD too), but I think
> it is completely useless.

It's useful for testing, and for minimising the divergence in the
code.

