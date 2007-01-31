Return-Path: <linux-kernel-owner+w=401wt.eu-S1030513AbXAaS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513AbXAaS2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030511AbXAaS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:28:07 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:49768 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030513AbXAaS2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:28:05 -0500
Date: Wed, 31 Jan 2007 19:24:54 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>,
       Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
In-Reply-To: <20070131172410.GV3754@stusta.de>
Message-ID: <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
 <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
 <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
 <20070131172410.GV3754@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 18:24, Adrian Bunk wrote:
>On Wed, Jan 31, 2007 at 11:08:14AM +0100, Andi Kleen wrote:
>> Greg KH <greg@kroah.com> writes:
>> > 
>> > What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
>> > that floppy.c is?  Do you want everyone just to run screaming from
>> > kernel development never to be seen again?
>> 
>> Doing a from-scratch rewrite of floppy.c only supporting new
>> hardware and no obscure formats ("newfloppy.c") would be an excellent 
>> newbie project imho.  This means for someone who is still pretty
>> new, but wants to get their fingers wet with more complicated changes.
>> 
>> Then over time (old-)floppy.c could be phased out.
>>...
>
>Considering how widespread floppies are, these two sentences are
>contradictions.
>
>If the goal is to phase out the old floppy driver, a new driver will 
>have to gain support for more or less all hardware the old driver 
>supports...

How much different hardware does the (old)floppy.c do? I imagine that
today, where floppies phase out, there will be, in descending order:

 * USB floppy drives (atm handled by sd.c, could be better to have sf.c)
 * FDCs on mainboards
 * 1.44M drives
 * 1.2M drives

Even a working 2.88M, as cool as it sounds, never landed in my hands ever
since I've been into computing. Perhaps the oldest, smallest disk I once
had was a 360K 5.25", but the B floppy drive to read it was already
multi-compliant that read up to 1.2M disks.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
