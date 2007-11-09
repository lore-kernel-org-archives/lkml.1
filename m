Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbXKIPIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbXKIPIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbXKIPIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:08:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXKIPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:08:00 -0500
Date: Fri, 9 Nov 2007 07:06:09 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86 kprobes_64.c: make 3 functions static
Message-ID: <20071109070609.3ff46629@laptopd505.fenrus.org>
In-Reply-To: <20071109060326.GV26163@stusta.de>
References: <20071109060326.GV26163@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 07:03:26 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the following needlessly global functions static:
> - kprobe_handler()
> - trampoline_probe_handler()
> - post_kprobe_handler()
> 


while I appreciate your cleanups, I would like to ask you to be a bit
careful with the x86/ ones; some of these are for now deliberate to
make unification between the 32 and 64 ones possible.. eg we're working
on getting the more cosmetic (and in this context, removing a static is
more or less cosmetic) changes away so that "diff" shows us the *real*
differences between the 32 and 64 bit versions... adding back in the
static is the opposite direction ;)

So.. if you find ones that are real for both 32 and 64 bit, by all
means, but otherwise be a bit careful..

Greetings,
   Arjan van de Ven
-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
