Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYCCHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYCCHy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYCCHyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:54:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYCCHyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:54:18 -0500
Date: Mon, 3 Mar 2008 08:53:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080303075356.GB11526@elte.hu>
References: <200803030316.07165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Unresolved regressions
> ----------------------
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9938
> Subject		: building fails on lguest
> Submitter	: Cedric OLLIVIER <ollivier.cedric@gmail.com>
> Date		: 2008-02-11 15:34

this should be resolved by:

 commit db342d216ba9e060d8c5501eefc1d0a789c9e711
 Author: Tony Breeds <tony@bakeyournoodle.com>
 Date:   Tue Feb 19 08:16:03 2008 +0100

     lguest: fix build breakage

	Ingo
