Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXBSVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXBSVQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXBSVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:16:49 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:60042 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbXBSVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:16:48 -0500
Message-ID: <45DA139D.7070807@monatomic.org>
Date: Mon, 19 Feb 2007 23:16:13 +0200
From: Dan Aloni <da-x@monatomic.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
References: <20070217212918.GA26554@localdomain> <20070219155829.GA10111@cvg>
In-Reply-To: <20070219155829.GA10111@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Hi, Dan
>
> did you try setup forsed 8MB value on window->phys?
>
>   
Actually, I tried to force it at 4MB starting at 0xff800000 since it 
made much sense looking at the e820 map. Or maybe I misunderstood 
something. It crashed with this:

<7>[ 9237.432181] esb2rom: esb2rom_init_one(): Unable to register 
resource 0xff800000-0xffbfffff - kernel bug?
<1>[ 9237.432262] Unable to handle kernel paging request at 
ffffc20010500000 RIP:
<1>[ 9237.436910] [<ffffffff8041f7ba>] cfi_probe_chip+0x14a/0x10e0
<4>[ 9237.445246] PGD 12fc20067 PUD 12fc21067 PMD 12fcf6067 PTE 0
<0>[ 9237.451057] Oops: 0002 [1] SMP
<0>[ 9237.454346] do_IRQ: 1.251 No irq handler for vector

I can dump here the disassembly of cfi_probe_chip if it's interesting...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il

