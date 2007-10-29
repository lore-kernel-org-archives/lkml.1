Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXJ2HTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXJ2HTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbXJ2HTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:19:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbXJ2HTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:19:05 -0400
Date: Mon, 29 Oct 2007 00:18:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: Device mapper regression 2.6.23 vs. v2.6.23-6597-gcfa76f0
Message-Id: <20071029001832.05c0a372.akpm@linux-foundation.org>
In-Reply-To: <471BA729.6050206@m3y3r.de>
References: <471BA729.6050206@m3y3r.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007 21:23:21 +0200 Thomas Meyer <thomas@m3y3r.de> wrote:

> Hi.
> 
> I have an external hard drive with an encrypted partition. I am using
> kde so all i had to do under 2.6.23 was
>   "cryptsetup luksOpen /dev/sdb2 crypt-extern"
> 
> then udev/hal/kde (?)automatically created an desktop icon. i could
> click this icon to mount and open the drive.
> 
> when i do the luksOpen command with v2.6.23-6597-gcfa76f0 this icon is
> not created anymore.
> 
> a few commits were made in drivers/md, so it seems something broke.
> 
> config extract:
> 
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> # CONFIG_DM_MULTIPATH is not set
> CONFIG_DM_DELAY=m
> CONFIG_DM_UEVENT=y
> # CONFIG_FUSION is not set
> 
> any ideas?
> 

Could be DM breakage, could be udev/sysfs breakage.  Is it still happening
in current mainline?

And how come I'm seeing unresponded-to-for-a-week regression
reports on lkml?

