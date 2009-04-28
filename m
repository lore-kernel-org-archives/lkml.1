Return-Path: <linux-kernel-owner+w=401wt.eu-S1760353AbZD1P0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbZD1P0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762639AbZD1PXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:23:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:59328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762595AbZD1PXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:23:32 -0400
Message-ID: <49F71EF6.3050102@kernel.org>
Date: Tue, 28 Apr 2009 08:21:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
References: <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> 	<49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> 	<ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> 	<1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> 	<49EA4EB9.2030307@kernel.org> <49F6B1E6.7050008@kernel.org> 	<49F6B350.9080703@kernel.org> <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com>
In-Reply-To: <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Apr 28, 2009 at 09:42, Yinghai Lu <yinghai@kernel.org> wrote:
>> those about 1/3 dev_set_name() etc.
> 
> put_device()?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/base/core.c;h=4aa527b8a91381289eb175b33f46e3e418d10374;hb=HEAD#l848
> 
ok, normal release path seems right, put_device will free the name.

how about other fail path, that there is not put_device involved?

YH
