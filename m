Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXBTKSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXBTKSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 05:18:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbXBTKSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 05:18:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:45446 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809AbXBTKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 05:18:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kaVjEacGoQlGsymcMsNOzHtQSLv/GbVpG7z9T7kga8Yb6OR54LmCX0B3mFDogmpOKDGrmsNaFOVeLJJEg39H2b43ClcQbgxtkMZqjbt/41XWtRgOwnod5rFsHcGIqlloHEwhft+kuMHnAGd4oPzIFEd/AjYRRD8uMjB6RY9zVD8=
Date: Tue, 20 Feb 2007 13:15:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070220101516.GA10161@cvg>
References: <20070217212918.GA26554@localdomain> <20070219155829.GA10111@cvg> <45DA139D.7070807@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DA139D.7070807@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 11:16:13PM +0200, Dan Aloni wrote:
| Cyrill Gorcunov wrote:
| >Hi, Dan
| >
| >did you try setup forsed 8MB value on window->phys?
| >
| >  
| Actually, I tried to force it at 4MB starting at 0xff800000 since it 
| made much sense looking at the e820 map. Or maybe I misunderstood 
| something. It crashed with this:
| 
| <7>[ 9237.432181] esb2rom: esb2rom_init_one(): Unable to register 
| resource 0xff800000-0xffbfffff - kernel bug?
| <1>[ 9237.432262] Unable to handle kernel paging request at 
| ffffc20010500000 RIP:
| <1>[ 9237.436910] [<ffffffff8041f7ba>] cfi_probe_chip+0x14a/0x10e0
| <4>[ 9237.445246] PGD 12fc20067 PUD 12fc21067 PMD 12fcf6067 PTE 0
| <0>[ 9237.451057] Oops: 0002 [1] SMP
| <0>[ 9237.454346] do_IRQ: 1.251 No irq handler for vector
| 
| I can dump here the disassembly of cfi_probe_chip if it's interesting...
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| 

Hi,

send me the dump. I'll try to resolve the problem. To be fair I should
say that I'm not very familiar with a such hardware related stuff but
we could try anyway ;)

		Cyrill

