Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYGXKcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYGXKcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYGXKci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:32:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYGXKch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:32:37 -0400
Date: Thu, 24 Jul 2008 12:32:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: split spinlock implementations out into their own files
Message-ID: <20080724103223.GE28817@elte.hu>
References: <4887948A.9070301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887948A.9070301@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0022]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> ftrace requires certain low-level code, like spinlocks and timestamps, 
> to be compiled without -pg in order to avoid infinite recursion.  This 
> patch splits out the core paravirt spinlocks and the Xen spinlocks 
> into separate files which can be compiled without -pg.
>
> Also do xen/time.c while we're about it.  As a result, we can now use 
> ftrace within a Xen domain.

applied to x86/spinlocks, thanks Jeremy.

	Ingo
