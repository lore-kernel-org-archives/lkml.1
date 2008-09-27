Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbYI0Rvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbYI0Rvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbYI0RpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:45:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbYI0RpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:45:00 -0400
Date: Sat, 27 Sep 2008 19:44:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Bug #11237] corrupt PMD after resume
Message-ID: <20080927174439.GD26047@elte.hu>
References: <t_PcrlC6ypI.A.tGG.G7m3IB@albercik> <V8eU91268VO.A.L5.C_m3IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <V8eU91268VO.A.L5.C_m3IB@albercik>
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

> This message has been generated automatically as a part of a report of 
> recent regressions.
> 
> The following bug entry is on the current list of known regressions 
> from 2.6.26.  Please verify if it still should be listed and let me 
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> Subject		: corrupt PMD after resume
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-08-02 9:51 (57 days old)
> References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>
> 		  Jeremy Fitzhardinge <jeremy@goop.org>
> Patch		: http://marc.info/?l=linux-kernel&m=122001615314700&w=2

actually, it's now believed that this is a BIOS problem that affects all 
Linux versions. The aspect of v2.6.27 is that it happens to put kernel 
pagetables into the area that gets corrupted by the BIOS - and users 
notice that.

i.e. it's not a regression - unless i'm missing something.

	Ingo
