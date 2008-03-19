Return-Path: <linux-kernel-owner+w=401wt.eu-S1762470AbYCSUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762470AbYCSUxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYCSTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:47:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39825 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304AbYCSTrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:47:04 -0400
Date: Wed, 19 Mar 2008 20:46:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080319194648.GA20088@elte.hu>
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319190536.GA11432@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks Jeremy, i've queued them all up and the current x86/latest 
> branch should have them. They looked robust so far in my testing.

found a build bug on 32-bit & PAE - pud_populate() assumed too much 
about types:

In file included from arch/x86/mm/pgtable.c:3:
include/asm/pgalloc.h: In function 'pud_populate':
include/asm/pgalloc.h:93: error: dereferencing pointer to incomplete type

i've uninlined it and has trickled that through your series.

	Ingo
