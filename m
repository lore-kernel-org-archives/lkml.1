Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXLHE54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXLHE54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbXLHE5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:57:46 -0500
Received: from [212.12.190.8] ([212.12.190.8]:35760 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751935AbXLHE5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:57:45 -0500
From: Al Boldi <a1426z@gawab.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: git guidance
Date: Sat, 8 Dec 2007 07:56:21 +0300
User-Agent: KMail/1.5
Cc: Jakub Narebski <jnareb@gmail.com>, Andreas Ericsson <ae@op5.se>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Phillip Susi <psusi@cfl.rr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jing Xue <jingxue@digizenstudio.com>, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
References: <20071129105220.v40i22q4gw4cgoso@intranet.digizenstudio.com> <200712072204.48410.a1426z@gawab.com> <11272.1197056185@turing-police.cc.vt.edu>
In-Reply-To: <11272.1197056185@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712080756.21980.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Dec 2007 22:04:48 +0300, Al Boldi said:
> > Because WORKFLOW C is transparent, it won't affect other workflows.  So
> > you could still use your normal WORKFLOW B in addition to WORKFLOW C,
> > gaining an additional level of version control detail at no extra cost
> > other than the git-engine scratch repository overhead.
> >
> > BTW, is git efficient enough to handle WORKFLOW C?
>
> Imagine the number of commits a 'make clean; make' will do in a kernel
> tree, as it commits all those .o files... :)

.o files???

It probably goes without saying, that gitfs should have some basic 
configuration file to setup its transparent behaviour, and which would most 
probably contain an include / exclude file-filter mask, and probably other 
basic configuration options.  But this is really secondary to the 
implementation, and the question remains whether git is efficient enough.

IOW, how big is the git commit overhead as compared to a normal copy?


Thanks!

--
Al

