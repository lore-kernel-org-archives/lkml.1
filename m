Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbZDHPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbZDHPOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758758AbZDHPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:14:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33868 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbZDHPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:14:21 -0400
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
In-Reply-To: <20090408145440.GN12931@elte.hu>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
	 <20090408145440.GN12931@elte.hu>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 17:11:52 +0200
Message-Id: <1239203512.4557.2575.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 16:54 +0200, Ingo Molnar wrote:
> 
> >  kernel/sched.c                     |    2 -
> 
> Needs the ack of ... oh, never mind - this one is fine i guess ;-)

Ah, about that. This new preemption hook has slightly different
requirements than the current preempt-notifiers have (hence the new
hook), I was wondering if KVM (afaik currently the only preempt-notifier
consumer) could live with these requirements.

That is, could these be merged?

