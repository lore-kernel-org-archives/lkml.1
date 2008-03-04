Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbYCDMnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbYCDMnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYCDMnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:43:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYCDMnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:43:01 -0500
Date: Tue, 4 Mar 2008 13:42:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Klaus S. Madsen" <ksm@hjernemadsen.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
Message-ID: <20080304124241.GD29777@elte.hu>
References: <20080228194920.GJ17932@hjernemadsen.org> <47C739A6.5020608@zytor.com> <20080229070028.GK17932@hjernemadsen.org> <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303205227.GU17932@hjernemadsen.org>
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


* Klaus S. Madsen <ksm@hjernemadsen.org> wrote:

> > are you sure you ID-ed the right commit that broke things?
>
> I can't be sure. It was my third attempt, and there seems to be some 
> sort of Makefile trouble in that area, which causes the problem to 
> appear and disappear at random, unless I do a make clean && make. But 
> the triggering commit was found with make clean && make, and I made 
> sure that reverting the resulting commit did actually solve the 
> problem...

btw., even if it turns out to be the wrong commit, you sure poked in the 
right general area. This is one of the reoccuring problems with git 
bisection: a small mistake near the end of a long bisection session can 
point to the wrong commit. Especially with more sporadic failure modes 
it can be quite a challenge.

	Ingo
