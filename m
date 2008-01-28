Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYA1OE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYA1OE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYA1OES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:04:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbYA1OES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:04:18 -0500
Date: Mon, 28 Jan 2008 15:03:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Q: x86 suspend/hibernation code consolidation
Message-ID: <20080128140350.GB27928@elte.hu>
References: <200801260132.09529.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260132.09529.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> I'd like to move the 64-bit suspend/hibernation files from 
> arch/x86/kernel to arch/x86/power, modify the names of the 32-bit 
> files already in arch/x86/power and update the Makefiles accordingly, 
> but there are some changes queued for merging that touch the files in 
> question.

nice cleanup.

> When is the right time for making changes like that?

best would be after the x86.git merge. We could push this via x86.git in 
fact, to line it up with whatever other changes there might be. -mm 
would be fine too, if there are pending patches in this area in -mm. 
(and i recall you did some global-scope suspend/resume changes that 
might interfere?)

	Ingo
