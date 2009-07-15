Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZGOTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZGOTGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbZGOTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:06:16 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:39478 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932226AbZGOTGQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:06:16 -0400
X-SpamScore: -23
X-BigFish: VS-23(zba6lz1432R98dN936eM9371Pzz1202h10c0jzzz2dh87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4A5E2895.3040907@am.sony.com>
Date: Wed, 15 Jul 2009 12:05:57 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Joe Perches <joe@perches.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC: touchscreen driver
References: <20090710084323.GA6522@elf.ucw.cz>	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>	 <20090710103243.GB7789@elf.ucw.cz>	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>	 <20090713220726.GA28375@elf.ucw.cz>	 <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com> <1247535863.16528.6.camel@Joe-Laptop.home>
In-Reply-To: <1247535863.16528.6.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 15 Jul 2009 19:06:02.0062 (UTC) FILETIME=[4B967EE0:01CA057F]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2009-07-13 at 18:29 -0700, Arve Hjønnevåg wrote:
>> On Mon, Jul 13, 2009 at 3:07 PM, Pavel Machek<pavel@ucw.cz> wrote:
>>> -                       printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
>>> +                       printk(KERN_ERR "ts_work: i2c_transfer failed\n");
>> This will make it harder to read the kernel logs since the driver is 
>> no longer specified.
> 
> How about converting to:
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
> or
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> and pr_<level>()

dev_printk() and the related helpers in include/linux/device.h
might also be useful.

-Frank Rowand
---
Sony Corporation of America

