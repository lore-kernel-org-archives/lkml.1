Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXDCBeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXDCBeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXDCBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:34:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:10453 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965379AbXDCBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1OnuHuT5A2Ozrlcu4cTD69jHhHDEJnNup+I/4DfvVZD04OopImYewVmrLXEG4cOoANmGdeP7K46AUsNgry6Sw1+8lvNsNHWzpI2zcQppzpHA6T+T8dHU/5kO2ObvzcRW9Nf72z/I54kp3C1XI9QmNiW9kmKvjio228AVNn9N3g=
Message-ID: <a8e1da0704021834q7911fb56oa0f3f23651ee6be2@mail.gmail.com>
Date: Tue, 3 Apr 2007 01:34:13 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Tom Strader" <tom.strader@xilinx.com>
Subject: Re: Warning: unable to open an initial console.
Cc: "Chris Wedgwood" <cw@f00f.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070402232012.6716E64781D@mail78-cpk.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com>
	 <20070402224923.GA11208@tuatara.stupidest.org>
	 <20070402232012.6716E64781D@mail78-cpk.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Check if your U-boot enabled the udev, try diable the udev, then using
mknod to create the /dev/console.

Regards
dave


2007/4/2, Tom Strader <tom.strader@xilinx.com>:
> I checked /dev/ with U-boot and it shows the existence of /dev/console.
>
> From U-boot prompt:
>
> $ ls /dev
>  crw-------        0 Mon Apr 02 17:52:27 2007 console
>  crw-r--r--        0 Mon Apr 02 17:52:27 2007 null
>  crw-r--r--        0 Mon Apr 02 17:52:27 2007 zero
>
>
> Also, I added a printk in the jffs2_add_fd_to_list() routine in
> fs/jffs2/nodelist.c to print out the dirent adds and it shows console
> being added as follows:
>
> ...
> add dirent "var", ino #14
> add dirent "usr", ino #13
> add dirent "tmp", ino #12
> add dirent "sys", ino #11
> add dirent "sbin", ino #10
> add dirent "proc", ino #9
> add dirent "mnt", ino #8
> add dirent "linuxrc", ino #7
> add dirent "lib", ino #6
> add dirent "home", ino #5
> add dirent "etc", ino #4
> add dirent "dev", ino #3
> add dirent "bin", ino #2
> VFS: Mounted root (jffs2 filesystem).
> Freeing init memory: 76K
> add dirent "zero", ino #70
> add dirent "null", ino #69
> add dirent "console", ino #68
> Warning: unable to open an initial console.
> add dirent "watchdog", ino #262
> add dirent "udevstart", ino #261
> add dirent "udevsend", ino #260
> ...
>
> Any other ideas?
> Thanks,
> Tom
>
>
> -----Original Message-----
> From: Chris Wedgwood [mailto:cw@f00f.org]
> Sent: Monday, April 02, 2007 3:49 PM
> To: Tom Strader
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Warning: unable to open an initial console.
>
> On Mon, Apr 02, 2007 at 12:04:56PM -0700, Tom Strader wrote:
>
> > I have seen quite a few posts regarding unable to open an initial
> > console, but my system seems to have the necessary things in place
> > so I come looking for help.
>
> your rootfs/initramfs/initrd is missing a valid working /dev/console
>
> > VFS: Mounted root (jffs2 filesystem).
>
> check /dev/ on this filesystem
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
