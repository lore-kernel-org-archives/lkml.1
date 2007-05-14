Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbXENQas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbXENQas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXENQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:30:41 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657AbXENQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:30:40 -0400
Date: Mon, 14 May 2007 09:30:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Antonino Ingargiola <tritemio@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <20070514172138.1c870793@hyperion.delvare>
Message-ID: <alpine.LFD.0.98.0705140914410.6739@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
 <20070514081022.7fcee97f@hyperion.delvare> <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
 <20070514141437.631fcfd1@hyperion.delvare> <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
 <20070514172138.1c870793@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 May 2007, Jean Delvare wrote:
> 
> This is a side effect of an i2c-core cleanup. This is already fixed in
> lm_sensors 2.10.3 (libsensors.so.3.1.3).

So apparently that fixed it, but in general we do not allow these kinds of 
"need to have new xyz with new kernel". 

Kernels are supposed to be backwards compatible. Jean, what was it that 
changed, and why can't we just make them appear the same?

It may be that something like a sensors package isn't important enough to 
worry about (the machine still *works*, and everything else won't notice), 
but if it's a simple matter of adding some random file to /sysfs, we 
should just do it.

		Linus
