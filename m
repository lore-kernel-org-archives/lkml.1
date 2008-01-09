Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYAIVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYAIVBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYAIVBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:01:41 -0500
Received: from main.gmane.org ([80.91.229.2]:37197 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYAIVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:01:40 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu castet <castet.matthieu@free.fr>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Date: Wed, 9 Jan 2008 21:01:30 +0000 (UTC)
Message-ID: <loom.20080109T204856-761@post.gmane.org>
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it> <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it> <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it> <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it> <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it> <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it> <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com> <alpine.LSU.0.999.0801072226060.16143@be1.lrz> <4782A355.1070207@zytor.com> <alpine.LSU.0.999.0801072316440.16143@be1.lrz> <4782AED5.1060406@keyaccess.nl> <4782B4B9.2020608@zytor.com> <4782B515.3010008@keyaccess.nl> <4782BF77.80703@reed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071119 Iceape/1.1.7 (Debian-1.1.7-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David P. Reed <dpreed <at> reed.com> writes:

> And actually, if I had looked at the /sys/bus/pnp definitions, rather 
> than /proc/ioports, I would have noticed that port 80 was part of a 
> PNP0C02 resource set.   That means exactly one thing:  ACPI says that 
> port 80 is NOT free to be used, for delays or anything else.

I have some computers where port 0x80 is claimed by 8237A DMA controller [1]
But in this case it seems a lasy acpi programmer that doesn't want to convert
the hole in  0x80-0x8f range...


PS : I post from gmane web interface, so I can't keep CC.

[1]
This happen with a old 7 years old siemens PIII and a new hp core2duo.
state = active
io 0x0-0xf
io 0x80-0x8f
io 0xc0-0xdf
dma 4 

