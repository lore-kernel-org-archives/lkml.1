Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYBORS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYBORS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYBORSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:18:18 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41637 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbYBORSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:18:17 -0500
Date: Fri, 15 Feb 2008 18:18:15 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
In-Reply-To: <20080215083428.07246720.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0802151813480.30301@fbirervta.pbzchgretzou.qr>
References: <47B56BF2.4020600@openvz.org> <p73ejbe1ook.fsf@bingen.suse.de>
 <18357.30971.334517.722985@harpo.it.uu.se> <Pine.LNX.4.64.0802151343330.30301@fbirervta.pbzchgretzou.qr>
 <20080215083428.07246720.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15 2008 08:34, Randy Dunlap wrote:
>> >
>> >Doing it automatically is the only acceptable way, IMO.
>> 
>> For time being only.
>> 
>> The kernel (currently) only auto-mounts invisible filesystems.
>
>like /root, sysfs, futexfs, pipefs, anon_inodefs, bdev, devpts,
>hugetlbfs, inotifyfs ?

Yes?

/ (double case - initramfs or kernel), sysfs, devpts and
hugetlbfs can be mounted using mount(8) (or mount(2)), so
userspace can - and distro scripts do just that - mount them.

futexfs, pipefs, anon_inodefs, bdev and inotifyfs are 'invisible'
filesystems in that you cannot mount them yourself and that you
do not usually get to see them except probably when readlink(2)ing
on /proc/X/fd/N.
