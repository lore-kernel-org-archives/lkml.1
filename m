Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYLSXab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYLSXab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYLSXaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:30:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbYLSXaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:30:18 -0500
Date: Sat, 20 Dec 2008 00:30:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Mohr <andi@lisas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [patch] Re: [Bug #12100] resume (S2R) broken by Intel
	microcode module, on A110L
Message-ID: <20081219233006.GA17984@elte.hu>
References: <1229728524.5122.13.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229728524.5122.13.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Hi,
> 
> 
> This is in response to the following bug report:
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12100
> Subject         : resume (S2R) broken by Intel microcode module, on A110L
> Submitter       : Andreas Mohr <andi@lisas.de>
> Date            : 2008-11-25 08:48 (19 days old)
> Handled-By      : Dmitry Adamushko <dmitry.adamushko@gmail.com>

applied to tip/x86/microcode, thanks Dmitry!

The fix looks right but somewhat intrusive in scope, so i'm a bit 
reluctant to push it towards .28 straight away - without having feedback 
in the bugzilla. If feedback is positive (the bug reported there goes away 
completely) we can cherry-pick it over into x86/urgent, ok? And in any 
case i've marked it as a -stable backport for .28.1.

	Ingo
