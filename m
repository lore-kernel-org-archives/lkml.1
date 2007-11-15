Return-Path: <linux-kernel-owner+w=401wt.eu-S1763964AbXKOLaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763964AbXKOLaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXKOLac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:30:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:29055 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbXKOLab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jaqahQGgurDew5A9vzSXezTJsqf5p9qU88AE//3YN/h81U1lx795QKomy4byGZER27OTQaxJKb+vNHdQWQL4sEgAXGAU5/5tUkhf8LQYQuLgD4Na7nE4Sh4327bqMhBYcH/I8kEa65jTaA4X0mcQzzx12yWHS3aNbLekosr8u5s=
Message-ID: <b6fcc0a0711150330p276e8c74u3486b9c776f2c6ae@mail.gmail.com>
Date: Thu, 15 Nov 2007 14:30:29 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Daniel Lezcano" <dlezcano@fr.ibm.com>
Subject: Re: [2.6.24-rc2-git5] kernel panic when config_sysfs = n
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, gregkh@suse.de
In-Reply-To: <473C2854.90305@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <473C2854.90305@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/07, Daniel Lezcano <dlezcano@fr.ibm.com> wrote:
> When I tryed to boot with qemu a 2.6.24-rc2-git5 with sysfs disabled,
> the boot fails when trying to mount root partition:
>
> "VFS: Cannot open root device "hda2" or unknown-block(0,0)
> Please append a correct "root=" boot option; here are the available
> partitions:
> 0300    2097152 hda0300    2097152 hda driver: ide-disk
>   driver: ide-disk
>    0301     257008 hda1
>    0302    1839442 hda2
> 1600    4194302 hdc1600    4194302 hdc driver: ide-cdrom
>   driver: ide-cdrom
> Kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(0,0)"

>From CONFIG_SYSFS help text:

sysfs is currently used by the block subsystem to mount the root
partition.  If sysfs is disabled you must specify the boot device on
the kernel boot command line via its major and minor numbers.  For
example, "root=03:01" for /dev/hda1.
