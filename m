Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYAIQNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYAIQNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYAIQNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:13:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53638 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbYAIQNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:13:17 -0500
Date: Wed, 9 Jan 2008 17:13:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Introduce __die helper to X86_32
Message-ID: <20080109161306.GB17739@elte.hu>
References: <1199841502.6424.25.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199841502.6424.25.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Small step towards unifying traps_32|64.c.  No functional changes.  
> Pull out a small helper from an if() statement in die().
> 
> Marked as __kprobes as eventually we will want to call this from 
> do_page_fault similar to how X86_64 does it.

thanks, applied.

	Ingo
