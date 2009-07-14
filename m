Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZGNBog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZGNBog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZGNBof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:44:35 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4388 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZGNBof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:44:35 -0400
Subject: Re: HTC: touchscreen driver
From: Joe Perches <joe@perches.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
	 <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jul 2009 18:44:23 -0700
Message-Id: <1247535863.16528.6.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 18:29 -0700, Arve Hjønnevåg wrote:
> On Mon, Jul 13, 2009 at 3:07 PM, Pavel Machek<pavel@ucw.cz> wrote:
> > -                       printk(KERN_ERR "synaptics_ts_work_func: i2c_transfer failed\n");
> > +                       printk(KERN_ERR "ts_work: i2c_transfer failed\n");
> This will make it harder to read the kernel logs since the driver is 
> no longer specified.

How about converting to:

#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
or
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and pr_<level>()


