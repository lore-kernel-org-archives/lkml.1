Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYBKXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYBKXB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBKXBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:01:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYBKXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:01:49 -0500
Message-ID: <47B0D363.1020302@zytor.com>
Date: Mon, 11 Feb 2008 14:59:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some processors
References: <200802082347.25364.michael-lists@free-electrons.com> <20080208231130.GA10511@elte.hu> <200802112342.23493.michael-lists@free-electrons.com>
In-Reply-To: <200802112342.23493.michael-lists@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Opdenacker wrote:
> 
> Also note that for the sake of convenience and consistency
> between 32 and 64 bit, I move the declaration of force_mwait
> from kernel/cpu/amd.c to kernel/setup_32.c 
> (force_mwait is already defined in kernel/setup_64.c).
> 

NAK NAK NAK NAK NAK NAK NAK

This is the totally wrong thing to do.  The CPU initialization stuff 
should move *into* the CPU directory (unification based on the 
cleaned-up 32-bit code, not on the 64-bit code which is based on a fork 
of the pre-cleanup 32-bit code.)

	-hpa
