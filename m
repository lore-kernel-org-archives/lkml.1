Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbYCAUF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbYCAUF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbYCAUFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:05:09 -0500
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:52027 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbYCAUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:05:07 -0500
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 15:05:07 EST
Message-ID: <47C9B22D.6010003@the2masters.de>
Date: Sat, 01 Mar 2008 20:44:45 +0100
From: Stefan Hellermann <stefan@the2masters.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080218)
MIME-Version: 1.0
To: Pawel Plociennik <paplociennik@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] chroot= as a new kernel parameter
References: <200803011409.59526.paplociennik@gmail.com>
In-Reply-To: <200803011409.59526.paplociennik@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Plociennik schrieb:
> hi *real* hackers,
> 
> it is a my first post to lkml and I hope that you will have not been
> ignored me if I have done some incorrect thing.
> 
> In the short this patch has added a new chroot= kernel parameter which can be used
> to changing a chroot of an init process before it will has been runed.
> I use that for testing variouses distroes without making a separate partition but
> by copied a new root-fs to a new subdirectory on the my *base* filesystem.

Hi!

Gentoos initrd (build by genkernel) has support for a chrooted boot, the parameter is
called subdir=
Maybe other distros have something similar, it's easy to support this with a initrd/initramfs.

Cheers
Stefan

PS: This is my first post to lkml, too :)
