Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYHFH5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYHFH5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYHFH4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:56:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:36662 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYHFH4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=ws/JxSoExlc1d1CoYB6+gvgsZWjIkqfxHZ9eL1jg9pSzLl9dAayNcsRSfp6hR/HXUA
         25daa1boxlUwVrvpheZunTIcIZJEW0PzkdTMG0Nt8zzcqYa4VQn4YVE4iU77Rud8j2mv
         pxGCoRNkPZyiOU/3Re4MYhiiCOb04NeSdTOdU=
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT]: Networking
Date: Wed, 6 Aug 2008 10:21:55 +0200
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080805.190020.244441681.davem@davemloft.net> <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808051937410.15995@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808061021.56150.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Linus Torvalds wrote:
> 
> On Tue, 5 Aug 2008, David Miller wrote:
> > 
> > There was going to be the addition of the ath9k wireless driver but
> > there was some fallout that is being worked on right now (linux/list.h
> > changes needed lkml review, ath9k driver triggered some gcc aborts,
> > all kinds of fun stuff :-) so hopefully it will make it in the next
> > pass.  I tried to wait an extra day for it to be resolved, but that
> > was optimistic.
> 
> Talking about wireless driver updates - has anybody looked at the RaLink 
> wireless driver?  It's in the newer EeePC's (901 and 1000), and it 
> actually has a driver from the company which the comments make clear is 
> GPLv2 too, no apparent oddness or anything:
> 
> 	http://www.ralinktech.com.tw/data/drivers/2008_0708_RT2860_Linux_STA_v1.7.0.0.tar.bz2
> 
> which admittedly apparently has some trivial problems (with a trivial 
> patch as seen at
> 
> 	http://fedoraforum.org/forum/showthread.php?t=195429
> 
> I'd love to have that one working, since I have the hardware, and it's 
> actually reasonable (much more so than the original EeePC, in fact). What 
> channels should I go through? Is anybody working on integrating it 
> already?

Like the earlier rt2x00 drivers I am rewriting the driver as released by Ralink and
have put it in the rt2x00lib/mac80211 framework. Most of the code is currently done, and the
last part should be done this week. After that it is a matter of testing and comparing
register values with the Ralink driver for the last tweaks.

I doubt the driver will be ready/stable for 2.6.28, but it should be ready for 2.6.29.

Ivo


