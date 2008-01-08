Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYAHUC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYAHUC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYAHUCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:02:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYAHUCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:02:20 -0500
Date: Tue, 8 Jan 2008 21:01:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Matthew Wilcox <matthew@wil.cx>, Valdis.Kletnieks@vt.edu,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080108200143.GA23607@elte.hu>
References: <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu> <20080107213717.GB16309@parisc-linux.org> <26581.1199747065@turing-police.cc.vt.edu> <20080107231930.GC16309@parisc-linux.org> <4783A904.9030705@s5r6.in-berlin.de> <alpine.LFD.1.00.0801080902460.3148@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801080902460.3148@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> These things *are* fairly rare (most bugs by _far_ are of the trivial 
> stupid kind), but some of those things can stay around for a long 
> time, and it can take months of different people reporting similar 
> problems until somebody finally puts two and two together and sees the 
> pattern.

one common pattern i've noticed is bug dependency. In some areas we need 
to fix a series of 2-3 increasingly less trivial bugs to get enough test 
exposure, tester confidence and developer attention to trigger (and fix) 
the _truly_ bad bugs.

That's why agressive regression elimination (and prevention) is so 
important IMHO - trivial regressions can totally block testing of 
certain areas of code, and with an agressive 90 days release schedule 
every day counts.

	Ingo
