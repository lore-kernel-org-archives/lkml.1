Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZC3PBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZC3PBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZC3PBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:01:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53849 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZC3PBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:01:36 -0400
Message-ID: <49D0DE9A.309@garzik.org>
Date: Mon, 30 Mar 2009 11:00:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	<49CD7B10.7010601@garzik.org>	<49CD891A.7030103@rtr.ca>	<49CD9047.4060500@garzik.org>	<49CE2633.2000903@s5r6.in-berlin.de>	<49CE3186.8090903@garzik.org>	<49CE35AE.1080702@s5r6.in-berlin.de>	<49CE3F74.6090103@rtr.ca>	<20090329231451.GR26138@disturbed>	<20090330003948.GA13356@mit.edu>	<49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca>
In-Reply-To: <49D0DAD3.6030507@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ric Wheeler wrote:
>> Mark Lord wrote:
>>> Ric Wheeler wrote:
> ..
>>> The kernel can crash, and the drives, in practice, will still
>>> flush their caches to media by themselves.  Within a second or two.
>>
>> Even with desktops, I am not positive that the drive write cache 
>> survives a kernel crash without data loss. If I remember correctly, 
>> Chris's tests used crashes (not power outages) to display the data 
>> corruption that happened without barriers being enabled properly.
> ..
> 
> Linux f/s barriers != drive write caches.
> 
> Drive write caches are an almost total non-issue for desktop users,
> except on the (very rare) event of a total, sudden power failure
> during extended write outs.
> 
> Very rare.

Heck, even I have lost power on a plane, while a laptop in laptop mode 
was flushing out work.  Not that rare.


> Yes, a huge problem for server farms.  No question.
> But the majority of Linux systems are probably (still) desktops/notebooks.

But it doesn't really matter who is what majority, does it?  At the 
present time at least, we have not designated any filesystems "desktop 
only", nor have we declared Linux a desktop-only OS.

Any generalized decision that hurts servers to help desktops would be 
short-sighted.  Robbing Peter, to pay Paul, is no formula for OS success.

	Jeff



