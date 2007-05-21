Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXEUD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXEUD0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbXEUD0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:26:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbXEUD0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:26:46 -0400
Date: Sun, 20 May 2007 20:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]serial: make early_uart to use early_prarm instead of
 console_initcall
Message-Id: <20070520202332.145d93a6.akpm@linux-foundation.org>
In-Reply-To: <200705181900.17101.yinghai.lu@sun.com>
References: <200705181900.17101.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 19:00:16 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH]serial: make early_uart to use early_prarm instead of console_initcall
> 
> Make early_uart to use early_param, so uart console can be used earlier.
> Make it to be bootconsole with CON_BOOT flag, so can use console handover
> feature. and it will switch to corresponding normal serial console automatically.
> new command line will be
> 
> earlycon=uart,io,0x3f8,9600n8
> earlycon=uart,io,0x3f8,9600n8 console=tty0
> 
> it will print in very early stage
> Early serial console at I/O port 0x3f8 (options '9600n8')
> later for console it will print
> console handover: boot [uart0] -> real [ttyS0]

I'll queue this up for some testing, but I'd be a bit reluctant to send it
into Linus due to my poor understanding of what it actually does.  What
_is_ an early console, and how does it differ from a non-early one?

Someone help, please.

Coudl you please provide a patch against
Documentation/kernel-parameters.txt as well?

