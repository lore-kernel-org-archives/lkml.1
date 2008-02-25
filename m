Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbYBYCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbYBYCQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYBYCQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:16:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYBYCQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:16:00 -0500
Message-ID: <47C224D8.8070409@zytor.com>
Date: Sun, 24 Feb 2008 18:15:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] x86 - boot/header.S
References: <20080223082026.GA6747@cvg>
In-Reply-To: <20080223082026.GA6747@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Hi Peter, Sam,
> 
> could you take a look on x86/boot/header.S:280 please?
> 
> # Zero the bss
> 	movw	$__bss_start, %di
> 	movw	$_end+3, %cx
> 	xorl	%eax, %eax
> 	subw	%di, %cx
> 	shrw	$2, %cx
> 	rep; stosl
> 
> I wonder why is $_end there instead of $__bss_stop?
> Well, accroding to vmlinux_32.lsd both _end and __bss_stop
> are the same BUT __bss_stop is more convenient methink.
> Would it be usefull to change?

x86/boot/header.S goes with x86/boot/setup.ld and no other linker script.

	-hpa
