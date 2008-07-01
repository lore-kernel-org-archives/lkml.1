Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYGAGcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYGAGcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYGAGb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:31:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59401 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYGAGb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:31:57 -0400
Date: Tue, 1 Jul 2008 08:31:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-ID: <20080701063133.GC16642@elte.hu>
References: <200807010148.02135.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807010148.02135.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Hi,
> 
> The appended patch fixes a regression and is considered as 2.6.26 
> material. Everyone having a box with working suspend to RAM is gently 
> requested to test it and verify if it doesn't break things.
> 
> The patch applies to the current -git.

it's been under testing in tip/out-of-tree for about a week:

| commit ee901dc1b9ab94a37ba2efc296fe9ba72bc75adf
| Author:     H. Peter Anvin <hpa@zytor.com>
| AuthorDate: Tue Jun 24 23:03:48 2008 +0200
| Commit:     Ingo Molnar <mingo@elte.hu>
| CommitDate: Wed Jun 25 18:48:13 2008 +0200
|
|     x86 ACPI: normalize segment descriptor register on resume

no problems caused by it so far.

	Ingo
