Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZKJIBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZKJIBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 03:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZKJIBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 03:01:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZKJIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 03:01:41 -0500
Date: Tue, 10 Nov 2009 09:01:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style
 formatting
Message-ID: <20091110080135.GA32322@elte.hu>
References: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <20091110035812.GB29454@elte.hu>
 <20091110.165102.386189748263321818.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110.165102.386189748263321818.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> And I have a question.
> In tools/perf/command-list.txt, there is the word "mainporcelain".
> What does this mean?

tools/perf/ inherited the command-list.txt code from the Git project:

  git://git.kernel.org/pub/scm/git/git.git

in Git talk, 'porcelain' is the pretty stuff humans use. 'plumbing' is 
the lowlevel stuff humans dont get to see.

'mainporcelain' are the major commands you get listed when you type 
'perf' (or 'git').

( i've Cc:-ed the Git list as i never saw any real formal definition for
  this anywhere, maybe i got this wrong :-)

> Of course I searched this word on my dictionary, but cannot got an answer.
> I'm preparing the initial document for perf-bench.
> Can I add perf-bench with mainporcelain to command-list.txt?

yeah, i'd suggest to do that - that will make 'perf bench' show up in 
'perf' output.

	Ingo
