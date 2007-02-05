Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbXBEHs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbXBEHs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXBEHs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:48:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXBEHs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:48:28 -0500
Date: Mon, 5 Feb 2007 07:56:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org
Subject: v2.6.20-rt1, yum/rpm
Message-ID: <20070205065636.GA1652@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_20 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1746]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
usual place:

  http://redhat.com/~mingo/realtime-preempt/

more info about the -rt patchset can be found in the RT wiki:

  http://rt.wiki.kernel.org

This is a fixes-only release. Since the -rt tree has been closely 
tracking Linus' upstream kernel since -rc1, no new issues are expected - 
please re-report if anything is still unfixed.

There are lots of changes relative to 2.6.19-rt6 (the last stable 
release), but these are mostly fixes and other gradual improvements. KVM
is now enabled in the yum kernel on both i686 and x86_64 (and has been
enabled since around -rc1-rt1), the -rt tree tracks kvm-trunk (which is
a bit fresher than upstream KVM) and has a few additional paravirt
speedups implemented and enabled.

to build a 2.6.20-rt1 tree, the following patches should be applied:

  http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.20.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.20-rt1

the -rt YUM repository for Fedora Core 6 and 5, for architectures i686 
and x86_64 can be activated via:

   cd /etc/yum.repos.d
   wget http://people.redhat.com/~mingo/realtime-preempt/rt.repo

   yum install kernel-rt.x86_64   # on x86_64
   yum install kernel-rt          # on i686

   yum update kernel-rt           # refresh - or enable yum-updatesd

as usual, bugreports, fixes and suggestions are welcome,

	Ingo
