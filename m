Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZBIKzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZBIKzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZBIKzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:55:17 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:27300 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751534AbZBIKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:55:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=oTT30Cu9vfAn1RrllwH6MLbY4xRvbmvUWud8VfPn2VSDDGCMHD5sQi2Slk8CJA0JCbnieWyCofCGgvQzz2kEU1cBPmbICIby78ON6WrbMi59g7qf2pLH2NcK6iffxOshvpLrEkElO1F8fA3mYgf6Ze8OrXm43NIrQpXjAwZek38=  ;
X-YMail-OSG: zLcV1eUVM1myApQRA8Tzdv7TpJvUSIltJeNewE9hsyHOlhspYQwBVhL1B9vvzPBLoWHBT_d8zUH6STB2mAbjfeDetXABmD0FwSJ4Wa6iUy2FAVVz0s5_raQjwzOWvcYdqVW7F61_k.NTMYd_uwtTZXsR9_4jQQKxxFL7nYA6z0puosyID7060YdHY_HBIA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: wixor <wixorpeek@gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
Date: Mon, 9 Feb 2009 21:54:45 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com> <200902091659.21446.nickpiggin@yahoo.com.au> <c43b2e150902090206n4fd45d24xedbf5074535cf574@mail.gmail.com>
In-Reply-To: <c43b2e150902090206n4fd45d24xedbf5074535cf574@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902092154.46695.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 21:06:32 wixor wrote:
> Yes, that is somehow better. BUG is gone, it says now
>    vmap allocation failed: use vmalloc=<size> to increase size
> and then
>    ioremap failed.
> The driver still doesn't work however.

Quite possibly then it is a bad size being passed to ioremap.
(as you said you still have a few hundred GB of vmalloc space
free).

Could you printk the value of the 'size' variable, and also
call WARN() in the case of allocation failure?

