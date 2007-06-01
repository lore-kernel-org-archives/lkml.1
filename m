Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXFAUkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXFAUkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762998AbXFAUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:40:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55739 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762503AbXFAUj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:39:59 -0400
Message-ID: <4660841D.5050003@garzik.org>
Date: Fri, 01 Jun 2007 16:39:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tuncer Ayaz <tuncer.ayaz@gmail.com>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: 2.6.22 libata spindown
References: <4ac8254d0706011314g5468f02m3cf5a5281bd30018@mail.gmail.com>
In-Reply-To: <4ac8254d0706011314g5468f02m3cf5a5281bd30018@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tuncer Ayaz wrote:
> I'm still seeing the libata warning that disks were not spun down
> properly on the following two setups and am wondering whether I need
> a new shutdown binary or the changeset mentioned below is not meant
> to fix what I'm triggering by halt'ing.
> 
> If it's not a bug I will try to update my shutdown utility and if
> that does not work I promise not to bother lkml about a problem
> caused by my userland. If it is a bug I hope it will be of interest
> for 2.6.22 bug tracking.
> 
> Setup 1:
> SATA 1 Disks
> AMD64 3200+
> nVidia nForce 3 250 (Ultra?)
> Debian i386 Unstable
> 
> Setup 2:
> SATA 2 disks
> Core 2 Duo E6600
> Intel 975X
> Debian x86_64 Unstable
> 
> Just to be clear what warning I'm talking about:
> DISK MIGHT NOT BE SPUN DOWN PROPERLY. UPDATE SHUTDOWN UTILITY
> For more info, visit http://linux-ata.org/shutdown.html


IIRC, Debian was the one OS that really did need a shutdown utility 
update, as the message says :)

	Jeff


