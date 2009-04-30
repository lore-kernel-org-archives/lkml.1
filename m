Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbZD3JMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbZD3JMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759723AbZD3JMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:12:05 -0400
Received: from web32602.mail.mud.yahoo.com ([68.142.207.229]:45788 "HELO
	web32602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754170AbZD3JMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:12:03 -0400
Message-ID: <926930.45651.qm@web32602.mail.mud.yahoo.com>
X-YMail-OSG: 1ahfCBMVM1mwx2eSFyVnfkdH0LhK6jZvrLKXzBa7cKH_0pkHDBd_agZ3UKPboW8qLEyvwpFpUb5zZSmajNCc1xFA3nKg6Wgj11CvrrPi29aVphMGkRqRrMdC0yeJk9ibK0b1N.McmDyzafC9.egtrhBDfz38zksW.ClKkffp2H619icCYlZ5FqKq3ucvPkqtOKp3tNRrpey1501PBo6fkDQi9R42Ixc1dqclvNcHMn9qalykUJ1INC3kneLezyOTZ7f7NGepkIT69RrJPgIvA1uL1A6rGyTkXe4pidtw1V.hZLSBaRRb
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org> <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <884894.99151.qm@web32602.mail.mud.yahoo.com> <20090429174154.GK8633@ZenIV.linux.org.uk> <225539.25847.qm@web32607.mail.mud.yahoo.com> <20090429181041.GM8633@ZenIV.linux.org.uk>
Date: Thu, 30 Apr 2009 02:12:00 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090429181041.GM8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Al Viro <viro@ZenIV.linux.org.uk>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>; Mike Galbraith <efault@gmx.de>; Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 8:10:41 PM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Wed, Apr 29, 2009 at 10:51:35AM -0700, Martin Knoblauch wrote:
> > 2.6.30-rc3-git2:
> > 
> > rootfs / rootfs rw 0 0
> > /proc /proc proc rw,relatime 0 0
> > none /sys sysfs rw,relatime 0 0
> > none /dev tmpfs rw,relatime,mode=755 0 0
> > /dev/root / ext3 rw,relatime,errors=continue,data=writeback 0 0
> > none /dev tmpfs rw,relatime,mode=755 0 0
> > /proc /proc proc rw,relatime 0 0
> > /proc/bus/usb /proc/bus/usb usbfs rw,relatime 0 0
> > /sys /sys sysfs rw,relatime 0 0
> > none /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
> > /dev/cciss/c0d0p1 /boot ext3 rw,relatime,errors=continue,data=writeback 0 0
> > none /dev/shm tmpfs rw,relatime 0 0
> > /dev/cciss/c0d0p4 /scratch ext2 rw,noatime,errors=continue 0 0
> > none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
> > sunrpc /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
> 
> Cute...  I wonder how that second mount(2) managed to succeed.  Could you
> check what explicit mounting of sysfs on that point *again* does?
Hi Al,

 by now I know a bit more. Starting with 2.6.29, the

none /sys sysfs rw 0 0

line is already in /proc/mounts when entering userspace. So I guess it comes out of my initrd. Again, what changed?

Cheers
Martin

