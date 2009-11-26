Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZKZWkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZKZWkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZKZWkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:40:01 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:41021 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZKZWkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:40:01 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
References: <20091124200127.GA5751@redhat.com>
	<20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com>
	<20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com>
	<20091126172524.GA14768@redhat.com>
	<20091126182226.GF12355@darkmag.usersys.redhat.com>
	<20091126202312.GA21945@redhat.com>
	<19214.63688.860929.962005@cargo.ozlabs.ibm.com>
X-Yow: ...Get me a GIN and TONIC!!...make it HAIR TONIC!!
Date: Thu, 26 Nov 2009 23:40:02 +0100
In-Reply-To: <19214.63688.860929.962005@cargo.ozlabs.ibm.com> (Paul
	Mackerras's message of "Fri, 27 Nov 2009 08:53:12 +1100")
Message-ID: <m28wdsykot.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> I believe gdb has code to recognize this kind of sequence and run
> through it without stopping until after the bne, precisely to avoid
> this problem.

See gdb/rs6000-tdep.c:ppc_deal_with_atomic_sequence.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
