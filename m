Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbXENT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbXENT4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXENT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:56:46 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35227 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbXENT4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:56:45 -0400
Date: Mon, 14 May 2007 21:55:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org
Subject: Re: dm(-crypt) and /dev/disk/by-label/
In-Reply-To: <46485EC7.8040006@ums.usu.ru>
Message-ID: <Pine.LNX.4.61.0705142154110.9570@yvahk01.tjqt.qr>
References: <200705141348.48099.mail@earthworm.de> <46485EC7.8040006@ums.usu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 19:06, Alexander E. Patrakov wrote:
> Christian Hesse wrote:
>> Hello everybody,
>> 
>> I have ext3 filesystems with labels on devicemapper crypted devices. These
>> do not show up in /dev/disk/by-label/, in contrast to filesystems of my
>> "real" partitions. Is this the expected behaviour or what could go wrong?
>
> Some distributions intentionally tell udev to ignore device-mapper devices
> completely, for the following reasons:
>
> 1) without this prohibition, udev creates /dev/dm-* devices, and LILO breaks
> completely if they are present instead of the correct /dev/mapper/* nodes
> created by dmsetup and similar tools

Uhm, openSUSE does not have this prohibition. /dev/dm-\d+ exist,
/dev/mapper/\w+ exist, as do /dev/disk/by-label/\w+. Though,
it uses GRUB by default.


	Jan
-- 
