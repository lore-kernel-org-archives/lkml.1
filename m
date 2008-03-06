Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbYCFQUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbYCFQUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbYCFQT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:19:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697AbYCFQT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:19:56 -0500
Date: Thu, 6 Mar 2008 17:21:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: pageexec@freemail.hu
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Srinivasa DS <srinivasa@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 - Enhance DEBUG_RODATA support - alternatives
Message-ID: <20080306162123.GA27163@one.firstfloor.org>
References: <20080306140105.GC28438@elte.hu> <47D014E1.30964.22A9390F@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D014E1.30964.22A9390F@pageexec.freemail.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> you probably want a BUG_ON instead (or some graceful recovery) else
> the NULL deref will trigger with IRQs off...

FWIW oopses don't have any trouble with interrupts being off.
So BUG_ON wouldn't add much value.

-Andi

