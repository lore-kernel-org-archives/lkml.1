Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKBTPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKBTPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYKBTPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:15:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:54119 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752740AbYKBTPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:15:09 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/xqw5nltHxO6VFcMsv3fLVDCXK1MfvwDUNIRTwCP
	33ht5zy6OzKQlj
Date: Sun, 2 Nov 2008 20:15:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: The Peach <smartart@tiscali.it>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: kuroboxHG.dts compile FATAL ERROR on 2.6.26
In-Reply-To: <20081102132442.77e3bf93@tiscali.it>
Message-ID: <Pine.LNX.4.64.0811022011150.14486@axis700.grange>
References: <20081102132442.77e3bf93@tiscali.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2008, The Peach wrote:

> Hello all
> I'm updating the kernel on my kurobox and I'm stuck with an error when I 
> try to compile the dts file, here is the exact error:
> 
> 
> # dtc -f -I dts -O dtb -o kuroboxHG.dtb -V 16 kuroboxHG.dts
> DTC: dts->dtb  on file "kuroboxHG.dts"
> kuroboxHG.dts:21 syntax error
> FATAL ERROR: Couldn't read input tree
> 
> even if I remove line 21 I get:
> 
> # dtc -f -I dts -O dtb -o kuroboxHG.dtb -V 16 kuroboxHG.dts
> DTC: dts->dtb  on file "kuroboxHG.dts"
> kuroboxHG.dts:28 syntax error
> FATAL ERROR: Couldn't read input tree

Looks like you're using an old version of dtc. Try using dtc from the same 
kernel from which .dts you're compiling:

linux-2.6/arch/powerpc/boot/dts$ ../dtc -I dts -O dtb -V 16 -o /tmp/kuroboxHG.dtb kuroboxHG.dts
DTC: dts->dtb  on file "kuroboxHG.dts"

> sorry, but I'm totally ignorant about dts syntax and can't correct any error.
> Any help will be greately appreciated :)

powerpc specific questions are better directed to linuxppc-dev@ozlabs.org

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
