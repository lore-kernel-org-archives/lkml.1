Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYAFNjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYAFNjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYAFNjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:39:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbYAFNjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:39:12 -0500
Date: Sun, 6 Jan 2008 14:37:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Vivek Goyal <vgoyal@redhat.com>,
       hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20080106133729.GB2481@elte.hu>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com> <20080103195201.GC6392@linux.vnet.ibm.com> <200801032242.01425.rjw@sisk.pl> <20080104122816.GF4514@linux.vnet.ibm.com> <20080104155415.GC6007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104155415.GC6007@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> So I went ahead and bisected -mm, and the culprit is git-x86. It boots 
> fine before it, but with git-x86 applied, it fails to boot.
> 
> Ingo/Thomas, could you please point me to the git-x86 tree so that I 
> can bisect it? (with instructions on how to pull the -mm branch, I 
> managed to pull the master branch, but not the -mm branch)

sure:

--------------{ x86.git instructions }---------->

 git-clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git linux-2.6.git
 cd linux-2.6.git
 git-branch x86
 git-checkout x86
 git-pull git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git mm
 git-log HEAD@{1}.. # see what's in #mm

(do subsequent pulls via "git-pull --force", as we frequently rebase the
git tree. NOTE: this might override your own local changes, so do this
only if you dont mind about losing thse changes in that tree.)
