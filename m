Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZAGEmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZAGEmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 23:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZAGEmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 23:42:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:40803 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZAGEma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 23:42:30 -0500
Subject: Re: powerpc: introduce asm/swab.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <200901070400.n0740Ore002063@hera.kernel.org>
References: <200901070400.n0740Ore002063@hera.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 15:42:20 +1100
Message-Id: <1231303340.14860.61.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 04:00 +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=156ca2bbf6503a02d7d6829886ce381d572de66e
> Commit:     156ca2bbf6503a02d7d6829886ce381d572de66e
> Parent:     8cdd3a9261e8efe36aeb6c708edb76d7e2b5d13f
> Author:     Harvey Harrison <harvey.harrison@gmail.com>
> AuthorDate: Tue Jan 6 14:56:23 2009 -0800
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Tue Jan 6 18:10:27 2009 -0800
> 
>     powerpc: introduce asm/swab.h
>     
>     Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Was this tested ? I see no arch maintainer signed-off here, it appears
to at least break ppc32, and contains hunks that paulus says were
explicitely nacked (removing of our ld_* macros) etc...

Linus, please revert.

Cheers,
Ben.


