Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXKROjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXKROjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbXKROjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 09:39:32 -0500
Received: from rtr.ca ([76.10.145.34]:3698 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbXKROjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 09:39:31 -0500
Message-ID: <47404EA1.5010902@rtr.ca>
Date: Sun, 18 Nov 2007 09:39:29 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: kernel coder <lhrkernelcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: increased number of cycles
References: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
In-Reply-To: <f69849430711172131j41c21d84y2ac10759eff29eb7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel coder wrote:
> hi,
>         I'm trying to add some code to netif_receive_skb function in
> dev.c file . The cycles consumed by that code was around 16 cycles on
> Dual Core Opetron machine.I'm working on that code for last 6 months
> now and the consumed cycles have always been around 16 cycles .I don't
> touch any other part of kernel .
> 
> But for last 4 days the consumed cycles have suddenly increased to
> around 35 cycles . I'm using RDTSC instruction to profile the
> code.There is no change in code and the kernel version is also the
> same .I am assuming that there  must be something wrong with hardware.
..

A cache miss ?
