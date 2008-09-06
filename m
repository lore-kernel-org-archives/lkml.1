Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYIFFin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYIFFin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYIFFig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:38:36 -0400
Received: from gw.goop.org ([64.81.55.164]:43848 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYIFFif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:38:35 -0400
Message-ID: <48C21759.4020503@goop.org>
Date: Fri, 05 Sep 2008 22:38:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86] fs, gs purpose & multicore prog
References: <200809031109.45660.goretux@gmail.com> <200809051317.11116.goretux@gmail.com> <48C1477B.6060500@goop.org> <200809060109.52419.goretux@gmail.com>
In-Reply-To: <200809060109.52419.goretux@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> I know these things ;) but what I wanted to know is the "x86 architectural 
> details". In fact, I saw that during the machine init the BIOS select a cpu on 
> the bus to be the BSP (bootstrap proc). The others are then the APs (Appli 
> proc). Then the kernel runs on the BSP. What I wonder is how the kernel gives 
> execution flow to the APs.
>   

See arch/x86/kernel/smpboot.c (esp do_boot_cpu()), and chapter 7 of
"Intel® 64 and IA-32 Architectures Software Developer’s Manual", volume 3a.

    J
