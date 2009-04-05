Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZDEXlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZDEXlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZDEXk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:40:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46638 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZDEXkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:40:55 -0400
Message-ID: <49D9417D.8060309@zytor.com>
Date: Sun, 05 Apr 2009 16:40:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-git12 breaks vga=0x0f07 on MSI/Intel GPU
References: <20090405231425.GC17934@one.firstfloor.org>
In-Reply-To: <20090405231425.GC17934@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hi,
> 
> Something between 2.6.29 and 2.6.29-git12 broke vga=0x0f07 text mode
> on one of my test boxes. The text mode display is still (barely)visible, 
> but the display contents continuous move over the screen horizontally while
> flickering. Without the option in 80x25 mode it still works. 2.6.29
> also works fine.
> 
> This is a MSI system with integrated Intel GPU.
> 
> 00:02.1 Display controller: Intel Corporation: Unknown device 29c3 (rev 02)
> 
> Please tell me if you need more information, i'm not sure
> what I should collect.
> 

vga=0xf07 (80x60) was broken until recently; it actually implemented the
equivalent of "vga=0xf01" (80x50).

Can you boot 2.6.22 with "vga=0xf07" on this box, and if so, how does it
behave?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

