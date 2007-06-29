Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXF2JJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXF2JJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 05:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbXF2JJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 05:09:29 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:13219 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbXF2JJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 05:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OGp7t08scogSuI77NuGfH4c/iwl/Mv7R5oxwd4fdvTGYb5p1TrpBVK2UV+5YouxvZa2ZqFe4gnjuluaNkXH8pFxgz+Fv6g1iPcXn0AMDMqZ6e9l6xxoyRDgq3N0Z/51Bvu2NTXUbgtQcaPoeYnTPRNi764RZNzpUdZUQGS7hy7I=
Message-ID: <4dde4acb0706290209n40d5e0adve6a3713513a6a724@mail.gmail.com>
Date: Fri, 29 Jun 2007 14:39:27 +0530
From: "Midhun Agnihotram" <agnimidhun@gmail.com>
To: "=?ISO-8859-1?Q?Hans-J=FCrgen_Koch?=" <hjk@linutronix.de>
Subject: Re: Fwd: Mounting MMC card
Cc: jdi@l4x.org, drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <200706291038.58358.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>
	 <200706282210.23770.hjk@linutronix.de>
	 <4dde4acb0706290040p4f90b0b5q630b8e0bd5982908@mail.gmail.com>
	 <200706291038.58358.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I was talking about the file system on the card. Usually, you've
> got vfat on such a card. How about that?
>
> BTW, You mounted proc on /proc and sysfs on /sys, I hope?
>

    Yes I do have the support for vfat and msdos file system. I have
formatted the card on a Windows system with "FAT" file system.

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set


   Also, I have mounted proc and sysfs.

>
> No. You don't have jffs2 on your MMC, do you?
>
     I do not have a jffs2 on my MMC.

> >    I have seen the udev page. But I am a bit skeptic about
> > implementing it with my kernelas this kernel is from Microcross -
> > customized for CSB535FS board.
>
> As long as it's a reasonable recent kernel (>=2.6.15), it shouldn't
> be a problem.
>

     The kernel version is 2.6.16. So I guess there should not be a
problem. Any more things that I need to check??


Thanks,
Midhun.
