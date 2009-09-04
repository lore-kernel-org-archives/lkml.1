Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbZIDOtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbZIDOtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZIDOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:49:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZIDOtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:49:11 -0400
Date: Fri, 4 Sep 2009 16:48:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       dwmw2@infradead.org, sam@ravnborg.org, tglx@linutronix.de,
       David.Woodhouse@intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
	'make oldconfig'
Message-ID: <20090904144857.GA12872@elte.hu>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for David Woodhouse <dwmw2@infradead.org> wrote:

> Commit-ID:  5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9
> Gitweb:     http://git.kernel.org/tip/5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9
> Author:     David Woodhouse <dwmw2@infradead.org>
> AuthorDate: Tue, 30 Jun 2009 12:10:21 +0100
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 3 Sep 2009 10:57:20 -0700
> 
> x86: Don't silently override CONFIG_64BIT in 'make oldconfig'

-tip testing found that this commit broke the UML build:

/home/mingo/tip/arch/um/Makefile:52: 
/home/mingo/tip/arch/um/Makefile-x86: No such file or directory
make[1]: *** No rule to make target `/home/mingo/tip/arch/um/Makefile-x86'.  Stop.
make: *** [sub-make] Error 2

	Ingo
