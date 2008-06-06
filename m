Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYFFLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYFFLu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYFFLuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:50:14 -0400
Received: from ozlabs.org ([203.10.76.45]:54049 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYFFLuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:50:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18505.9321.453540.780399@cargo.ozlabs.ibm.com>
Date: Fri, 6 Jun 2008 21:50:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
In-Reply-To: <20080606013058.e5d52c97.akpm@linux-foundation.org>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606175358.a439d1bb.sfr@canb.auug.org.au>
	<20080606010149.4d757b92.akpm@linux-foundation.org>
	<20080606182206.8bc36f71.sfr@canb.auug.org.au>
	<20080606013058.e5d52c97.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Well OK.  But patches in fact _do_ go into Linux as a single linear
> stream of commits.

Well no, they don't.  Multiple people work on things independently and
then put their stuff together.  Sometimes there are then conflicts
that have to be sorted out.  That's what merging is all about.

>  But the whole git model ignores that reality and
> here we see the result.

No, the git model (and the BK model before it) expresses the reality
that there is lots of development going on in parallel in many
different places.

> And saying "git doesn't work like that - you don't understand" just
> doesn't cut it.  It is a tool's job to permit humans to implement the
> workflow which they wish to follow.  Not to go and force them into
> doing something inferior.

You'd prefer to be the bunny that keeps every single subsystem's
string of patches all bundled together in a single humungous quilt
series?  With all due respect (and with a sense of admiration at how
much patch-wrangling you already do), I don't think you'd scale that
far. :)

Paul.
