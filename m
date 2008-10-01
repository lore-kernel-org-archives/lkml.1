Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYJAXaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYJAXaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYJAXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:30:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:54017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYJAXaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:30:05 -0400
Date: Wed, 1 Oct 2008 16:29:50 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, benh@kernel.crashing.org,
       rostedt@goodmis.org, jonathan@jonmasters.org, sdietrich@suse.de
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
 interrupt handlers
Message-ID: <20081001162950.61887d08@infradead.org>
In-Reply-To: <20081001162333.e1509240.akpm@linux-foundation.org>
References: <20081001223213.078984344@linutronix.de>
	<20081001162333.e1509240.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 16:23:33 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I'm a bit surprised to see that there is no facility for per-cpu
> interrupt threads?
> 

per handler is the right approach (that way, if one dies, all other
interrupts will likely keep working)

now.. normally an interrupt only goes to one cpu, so effectively it is
per cpu already anyway

we should however make the irq threads follow the affinity masks of the
irq... that'd be an easy add-on and probably worthwhile.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
