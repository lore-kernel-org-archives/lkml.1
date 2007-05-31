Return-Path: <linux-kernel-owner+w=401wt.eu-S1758091AbXEaDN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091AbXEaDN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756004AbXEaDNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:13:50 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755728AbXEaDNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:13:50 -0400
Date: Wed, 30 May 2007 20:13:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Russell King <rmk@arm.linux.org.uk>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Message-Id: <20070530201335.94f73eb9.akpm@linux-foundation.org>
In-Reply-To: <200705291844.00308.yinghai.lu@sun.com>
References: <200705291844.00308.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 18:43:59 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH 4/5] serial: convert early_uart to earlycon for 8250

drivers/serial/8250_early.c: In function 'parse_options':
drivers/serial/8250_early.c:143: error: 'FIX_EARLYCON_MEM_BASE' undeclared (first use in this function)
drivers/serial/8250_early.c:143: error: (Each undeclared identifier is reported only once

That was with http://userweb.kernel.org/~akpm/config-sony.txt, but this is
going to break a whole pile of architectures (alpha, powerpc, others).

I think I'll give up on it now.
