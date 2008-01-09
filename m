Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYAIMFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYAIMFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYAIME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:04:58 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52794 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751149AbYAIME5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:04:57 -0500
Message-ID: <399880302.13852@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 9 Jan 2008 20:04:58 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801071440.14798.lists@naasa.net> <399849251.21417@ustc.edu.cn> <200801090713.15655.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801090713.15655.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCZg2-0001DE-RP@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 07:13:14AM +0100, Joerg Platte wrote:
> Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> > > /dev/sda6 on / type ext3 (rw,noatime,errors=remount-ro,acl)
> > > tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
> > > proc on /proc type proc (rw,noexec,nosuid,nodev)
> > > sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
> > > procbususb on /proc/bus/usb type usbfs (rw)
> > > udev on /dev type tmpfs (rw,mode=0755)
> > > tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> > > devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
> > > fusectl on /sys/fs/fuse/connections type fusectl (rw)
> > > /dev/sda7 on /tmp type ext2 (rw,noatime,errors=remount-ro,acl)
> > > /dev/sda8 on /export type ext3 (rw,noatime,errors=remount-ro,acl)
> > > /dev/sda1 on /winxp type ntfs (rw,umask=002,gid=10000,nls=utf8)
> >
> > So they are ext3/ext2/ntfs.  What if you umount ntfs? and ext2 if possible?
> 
> Unmounting ntfs doesn't help, hence I converted the remaining ext2 filesystem 
> to ext3, modified the fstab entry accordingly and rebooted. Now everything 
> seems to be fine! Top reports an idle system and there is no abnormal iowait 
> any longer! Seems to be ext2 was causing this! Later today I can try to 
> remount the filesystem as ext2 to be sure the bug shows up again.

Thank you for the clue. However I cannot reproduce the bug on
ext2/2.6.24-rc7. Can you provide more details? Thank you.

Fengguang

