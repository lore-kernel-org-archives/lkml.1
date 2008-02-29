Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbYB2VYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbYB2VYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYB2VYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:24:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48589 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbYB2VYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:24:34 -0500
Date: Fri, 29 Feb 2008 22:24:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA
	support - alternatives"
Message-ID: <20080229212421.GK27212@elte.hu>
References: <47C86D7A.5030608@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C86D7A.5030608@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The patch "x86 - Enhance DEBUG_RODATA support - alternatives" enables 
> the kernel for writing by clearing X86_CR0_WP allow privileged writes.  
> This won't work in a paravirt environment for two reasons:

ok, have reverted it and have pushed out a new x86.git.

	Ingo
