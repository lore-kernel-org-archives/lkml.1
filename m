Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYFRKot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYFRKot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYFRKok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:44:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbYFRKok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:44:40 -0400
Date: Wed, 18 Jun 2008 12:44:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
Message-ID: <20080618104420.GI15255@elte.hu>
References: <1213138710.26530.51.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213138710.26530.51.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0099]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Hi Gregory,
> 
> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
> 
> I think we can do it simpler. Please take a look at the patch below.

applied your simplification to tip/sched-devel for testing. It still 
maintains strict FIFO queueing on uniprocessors, correct? (which is 
pretty much the only standards question we care about)

	Ingo
