Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0CDVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:22:41 -0500
Received: from lucidpixels.com ([75.144.35.66]:41932 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab0CDVWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:22:39 -0500
Date: Thu, 4 Mar 2010 16:22:38 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: dumpe2fs/dump/restore not working correctly for ext4?
In-Reply-To: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003041621550.17723@p34.internal.lan>
References: <alpine.DEB.2.00.1003041000140.18322@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Justin Piszcz wrote:

> Hi,
>
> I need to look into this more obviously and try other dumps etc, but I even 
> tried extracting a single (smaller) directory and it also segfaulted, has 
> dump been tested properly with ext4?
>
> # restore -f ../p34-root-2010-03-02.ext4dump -r .
> Segmentation fault (core dumped)

And from another day:

p34:/x2/bup/p34/2010-03-01/d# restore -f ../p34-root-2010-03-01.ext4dump 
-r .
Segmentation fault (core dumped)
p34:/x2/bup/p34/2010-03-01/d# ls
a/      core.restore.18181  l2/          nfs/             sbin/     var/
app@    dev/                lib/         opt/             selinux/  x@
appc@   etc/                lib64@       proc/            sys/      x2@
bin/    home/               lost+found/  r1/              tmp/      x3@
boot/   initrd/             media/       restoresymtable  usr/      x4@
cdrom@  l1/                 mnt/         root/            vapp@     x5@
p34:/x2/bup/p34/2010-03-01/d#

Does anyone use dump/restore with ext4?

Justin.

