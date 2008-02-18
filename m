Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYBRNz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYBRNz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYBRNzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:55:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYBRNzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:55:49 -0500
Date: Mon, 18 Feb 2008 14:55:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/jbd/journal.c: cleanups
Message-ID: <20080218135509.GC28851@elte.hu>
References: <20080217081935.GN3848@cs181133002.pp.htv.fi> <20080218070439.GG3029@webber.adilger.int> <20080218071229.GA1459@elte.hu> <20080218114936.GM8905@mit.edu> <20080218125702.GB15044@elte.hu> <20080218133127.GB12568@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218133127.GB12568@mit.edu>
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


* Theodore Tso <tytso@mit.edu> wrote:

> > So please deal with it like most other subsystem maintainers do and 
> > stop complaining about "code churn" - nobody but you changes the 
> > ext3 codebase, it's one of the codebases least affected by general 
> > kernel flux, it's an ultimate "leaf" subsystem.
> 
> Right, sorry.  I misread the filename; I thought this was against 
> fs/jbd2, instead of fs/jbd.

Btw., if people have problems with rejects from trivial patches, the 
'mpatch' tool does wonders in resolving the easy ones:

  http://oss.oracle.com/~mason/mpatch/

when you get a .rej file, first check whether mpatch can resolve it 
conflict-free:

  mpatch -d kernel/somefile.c.rej

if there are no conflicts then:

  mpatch -a kernel/somefile.c.rej

quilt refresh, review the result and it's done in the majority of cases.

	Ingo
