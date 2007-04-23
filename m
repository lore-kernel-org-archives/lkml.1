Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXDWWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXDWWGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbXDWWGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:06:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbXDWWGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:06:18 -0400
Message-ID: <462D2DD5.7000701@zytor.com>
Date: Mon, 23 Apr 2007 15:06:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Matt Ranon <mranon@javadevices.com>
CC: linux maillist <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
References: <875184.9239.qm@web88101.mail.re2.yahoo.com>
In-Reply-To: <875184.9239.qm@web88101.mail.re2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Ranon wrote:
> The Jem team is pleased to announce the release of Kcli, an in-kernel command line interface. Kcli is intended for a special class of embedded Linux applications. The Linux kernel has become the defacto standard OS for embedded applications. This means that Linux is getting bent in some ways that may appear strange to some. One of these ways, is embedded applications that do not use user space. User space consists of a statically linked, one line program, that simply sleeps forever, transforming Linux into a classical embedded RTOS. VxWorks developers will understand what we are talking about, and they may recall how much they depend on the VxWorks shell. Kcli attempts to meet the need for a shell for this class of embedded Linux applications. 

We already have that, it's called initramfs; you can use either busybox 
or klibc ash in this space, and no need to run it in kernel space.

Running this kind of crap in kernel space is lunacy in the extreme.

	-hpa

