Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYJVTzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYJVTzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYJVTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:54:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:60214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYJVTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:54:53 -0400
Date: Wed, 22 Oct 2008 12:55:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: sched: deep power-saving states
Message-ID: <20081022125508.2ccea6e1@infradead.org>
In-Reply-To: <1224704992.20069.71.camel@twins>
References: <48FF2DDC.5010600@gmail.com>
	<20081022064738.05818670@infradead.org>
	<48FF3321.4060809@novell.com>
	<20081022070701.567f1c9a@infradead.org>
	<48FF3829.8040704@novell.com>
	<20081022073616.5eb150fa@infradead.org>
	<1224704992.20069.71.camel@twins>
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

On Wed, 22 Oct 2008 21:49:52 +0200
Peter Zijlstra <peterz@infradead.org> wrote:
> 
> This still leaves us with the worst case IRQ response as given by the
> deepest C state. Which might be un-desirable.

that's a different problem in a different problem space.
> 
> jcm was, once upon a time, working on dynamically changing the idle
> routine, so that people who care about wakeup latency can run
> idle=poll while their application runs, and the acpi C state stuff
> when nobody cares.
> 
> This could of course then be tied into the PM QoS stuff Mark has been
> doing.

in fact you already have this *exactly* today; this isn't future
technology.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
