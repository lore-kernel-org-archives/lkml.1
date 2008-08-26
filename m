Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYHZImt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYHZImt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYHZIml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:42:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbYHZImk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:42:40 -0400
Date: Tue, 26 Aug 2008 10:42:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joshua Hoblitt <j_kernel@hoblitt.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080826084219.GE27080@elte.hu>
References: <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu> <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com> <20080823002235.GL23377@hoblitt.com> <86802c440808222252j6f900f1dlfbf1378a7bc35ee4@mail.gmail.com> <20080823104311.GC25904@elte.hu> <20080826083534.GH10646@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826083534.GH10646@hoblitt.com>
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


> Enabling the nmi_watchdog doesn't produce anything at all (I double
> checked the .config... it should be working). [...]

do the NMI counts in /proc/interrupts increase about once per second, on 
every CPU? Do you wait for the deadlock on a text (VGA) console, to make 
sure you see any NMI watchdog printout?

	Ingo
