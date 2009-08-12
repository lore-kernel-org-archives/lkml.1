Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZHLQYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZHLQYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZHLQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:24:04 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64296 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbZHLQYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:24:03 -0400
MIME-Version: 1.0
In-Reply-To: <35C3744979512D47ABD7DBA7920B2DBB091F50@HBMNTX3.hbm.com>
References: <35C3744979512D47ABD7DBA7920B2DBB091F50@HBMNTX3.hbm.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 12 Aug 2009 18:23:48 +0200
Message-ID: <ac3eb2510908120923w4a3bc4efuc747a80ed13ccc31@mail.gmail.com>
Subject: Re: automagic udev device node creation?
To: "Sander, Tim" <Tim.Sander@hbm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 18:04, Sander, Tim<Tim.Sander@hbm.com> wrote:
> I have written a simple mmap test driver which seems to work so far.=20
> The only problem i have, is that no udev device node is automatically =
> created?=20
> So i really would like to know what part is missing to make udev =
> automatically create
> the device node?
>
> Everything works alright if i just create the device node by hand.
>
> I suspect that these should be created out of the sysfs information =
> created by the module.

Assign the "devt" value in the registered "struct device" with the
major/minor value of your device instance.

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/device.h;h=aebb81036db2d368a7b55664f5a2b9d102c5109d;hb=HEAD#l407

Kay
