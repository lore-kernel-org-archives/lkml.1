Return-Path: <linux-kernel-owner+w=401wt.eu-S1763894AbYA1XpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763894AbYA1XpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYA1Xo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:44:58 -0500
Received: from 1wt.eu ([62.212.114.60]:1636 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYA1Xo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:44:57 -0500
Date: Tue, 29 Jan 2008 00:07:46 +0100
From: Willy Tarreau <w@1wt.eu>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] X86: Fix trailing statements should be on next line
Message-ID: <20080128230746.GL8953@1wt.eu>
References: <20080129000744.698639d3@paolo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129000744.698639d3@paolo-desktop>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

On Tue, Jan 29, 2008 at 12:07:44AM +0100, Paolo Ciarrocchi wrote:
> Fix trailing statements should be on next line

> -if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
> -if ( partial_status & SW_C2 )          printk("SW: condition bit 2\n");
> -if ( partial_status & SW_C1 )          printk("SW: condition bit 1\n");
> -if ( partial_status & SW_C0 )          printk("SW: condition bit 0\n");
> -if ( partial_status & SW_Summary )     printk("SW: exception summary\n");
> -if ( partial_status & SW_Stack_Fault ) printk("SW: stack fault\n");
> -if ( partial_status & SW_Precision )   printk("SW: loss of precision\n");
> -if ( partial_status & SW_Underflow )   printk("SW: underflow\n");
> -if ( partial_status & SW_Overflow )    printk("SW: overflow\n");
> -if ( partial_status & SW_Zero_Div )    printk("SW: divide by zero\n");
> -if ( partial_status & SW_Denorm_Op )   printk("SW: denormalized operand\n");
> -if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");

> +if ( partial_status & SW_Backward )
> +printk("SW: backward compatibility\n");
> +if ( partial_status & SW_C3 )
> +printk("SW: condition bit 3\n");
> +if ( partial_status & SW_C2 )
> +printk("SW: condition bit 2\n");
> +if ( partial_status & SW_C1 )
> +printk("SW: condition bit 1\n");
> +if ( partial_status & SW_C0 )
> +printk("SW: condition bit 0\n");
> +if ( partial_status & SW_Summary )
> +printk("SW: exception summary\n");
> +if ( partial_status & SW_Stack_Fault )
> +printk("SW: stack fault\n");
> +if ( partial_status & SW_Precision )
> +printk("SW: loss of precision\n");
> +if ( partial_status & SW_Underflow )
> +printk("SW: underflow\n");
> +if ( partial_status & SW_Overflow )
> +printk("SW: overflow\n");
> +if ( partial_status & SW_Zero_Div )
> +printk("SW: divide by zero\n");
> +if ( partial_status & SW_Denorm_Op )
> +printk("SW: denormalized operand\n");
> +if ( partial_status & SW_Invalid )
> +printk("SW: invalid operation\n");
>  #endif /* DEBUGGING */

Well, IMHO, the code was more readable and checkable in the initial
version. I think this is one example of exceptions where code appearance
is more important than style correctness.

Regards,
Willy

