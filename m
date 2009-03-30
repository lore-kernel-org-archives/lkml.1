Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZC3OEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZC3OEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZC3OEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:04:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZC3OEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:04:09 -0400
Message-ID: <49D0D08E.3090100@redhat.com>
Date: Mon, 30 Mar 2009 10:00:46 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	<49CD7B10.7010601@garzik.org>	<49CD891A.7030103@rtr.ca>	<49CD9047.4060500@garzik.org>	<49CE2633.2000903@s5r6.in-berlin.de>	<49CE3186.8090903@garzik.org>	<49CE35AE.1080702@s5r6.in-berlin.de>	<49CE3F74.6090103@rtr.ca>	<20090329231451.GR26138@disturbed>	<20090330003948.GA13356@mit.edu>	<49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca>
In-Reply-To: <49D0CDBA.7040702@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ric Wheeler wrote:
>>
>> People keep forgetting that storage (even on your commodity s-ata 
>> class of drives) has very large & volatile cache. The disk firmware 
>> can hold writes in that cache as long as it wants, reorder its writes 
>> into anything that makes sense and has no explicit ordering promises.
> ..
> 
> Hi Ric,
> 
> No, we don't forget about those drive caches.  But in practice,
> for nearly everyone, they don't actually matter.

Here I disagree - nearly everyone has their critical data being manipulated in 
large data centers on top of Linux servers. We all can routinely suffer when 
linux crashes and loses data at big sites like google, amazon, hospitals or your 
local bank.

It definitely does matter in practice, we usually just don't see it first hand :-)


> 
> The kernel can crash, and the drives, in practice, will still
> flush their caches to media by themselves.  Within a second or two.

Even with desktops, I am not positive that the drive write cache survives a 
kernel crash without data loss. If I remember correctly, Chris's tests used 
crashes (not power outages) to display the data corruption that happened without 
barriers being enabled properly.

> 
> Sure, there are cases where this might not happen (total power fail),
> but those are quite rare for desktop users -- and especially for the
> most common variety of desktop user:  notebook users (whose machines
> have built-in UPSs).
> 
> Cheers

Unless of course you push your luck with your battery and run it until really 
out of power, but in general, I do agree that laptops and notebook users have a 
reasonably robust built in UPS.

ric

