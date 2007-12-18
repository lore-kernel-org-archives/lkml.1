Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXLRPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXLRPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbXLRPoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:44:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55402 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757673AbXLRPoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:44:12 -0500
Date: Tue, 18 Dec 2007 16:43:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 21/21] [PATCH] finish processor.h integration
Message-ID: <20071218154319.GA11369@elte.hu>
References: <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com> <1197932050948-git-send-email-gcosta@redhat.com> <11979320551036-git-send-email-gcosta@redhat.com> <11979320603229-git-send-email!-gcosta@redhat.com> <11979320653161-git-send-email-gcosta@redhat.com> <11979320693300-git-send-email-gcosta@redhat.com> <20071218131932.GA9457@elte.hu> <20071218133818.GA9941@elte.hu> <4767CFC5.3010703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4767CFC5.3010703@redhat.com>
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


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

>> here the problem is apparently caused by your patch, a careless 
>> 'unification' of include file sections. 32-bit had this:
>
> Point is this patches do unification, but they are not just that, as 
> you can see. I am attempting to cleanup headers that appears not to be 
> used, [...]

do cleanups and unification in _separate_ patches. We do not want to 
change a SINGLE LINE OF SOURCE CODE in a patch that says "unify" and 
moves a block of code from one file to another, ok? If you see some 
obvious cleanups do it in pre or post patches (whichever looks more 
logical). That makes it totally bisectable and i can drop the bogus 
cleanup patch instead of having to drop a full unification patch.

	Ingo
