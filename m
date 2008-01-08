Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYAHWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYAHWrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYAHWrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:47:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45285 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYAHWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:47:08 -0500
Date: Tue, 8 Jan 2008 23:49:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, ananth@in.ibm.com,
       akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108224933.GB2117@one.firstfloor.org>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de> <20080108221802.GD21482@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108221802.GD21482@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 11:18:02PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Ananth N Mavinakayanahalli <ananth@in.ibm.com> writes:
> > >  kernel/kprobes.c        |    2 
> > >  kernel/test_kprobes.c   |  216 ++++++++++++++++++++++++++++++++++++++++++++++++
> > 
> > Can you put this somewhere else please? I know there are already some 
> > test files in kernel/* but imho they all belong into some other 
> > directory.
> 
> agreed - lib/* would be the right place i think - we've got 
> lib/locking-selftest.c already.

Why not test/       ?

I felt a little bad about not introducing arch/x86/test/ for pageattr-test.c either.

-Andi
