Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbZD2SLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbZD2SLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759749AbZD2SKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:10:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbZD2SKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:10:43 -0400
Date: Wed, 29 Apr 2009 19:10:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
Message-ID: <20090429181041.GM8633@ZenIV.linux.org.uk>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com> <20090429174154.GK8633@ZenIV.linux.org.uk> <225539.25847.qm@web32607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <225539.25847.qm@web32607.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:51:35AM -0700, Martin Knoblauch wrote:
> 2.6.30-rc3-git2:
> 
> rootfs / rootfs rw 0 0
> /proc /proc proc rw,relatime 0 0
> none /sys sysfs rw,relatime 0 0
> none /dev tmpfs rw,relatime,mode=755 0 0
> /dev/root / ext3 rw,relatime,errors=continue,data=writeback 0 0
> none /dev tmpfs rw,relatime,mode=755 0 0
> /proc /proc proc rw,relatime 0 0
> /proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
> /sys /sys sysfs rw,relatime 0 0
> none /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
> /dev/cciss/c0d0p1 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
> none /dev/shm tmpfs rw,relatime 0 0
> /dev/cciss/c0d0p4 /scratch ext2 rw,noatime,errors=continue 0 0
> none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
> sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0

Cute...  I wonder how that second mount(2) managed to succeed.  Could you
check what explicit mounting of sysfs on that point *again* does?
