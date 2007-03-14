Return-Path: <linux-kernel-owner+w=401wt.eu-S1030848AbXCNNsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848AbXCNNsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965424AbXCNNsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:48:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57455 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964953AbXCNNsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:48:00 -0400
Date: Wed, 14 Mar 2007 14:46:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 58/59] sysctl: Reimplement the sysctl proc support
Message-ID: <20070314134652.GC13486@elte.hu>
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com> <11689657073389-git-send-email-ebiederm@xmission.com> <20070314103832.GA16104@elte.hu> <b6fcc0a0703140348o18a4b24fye3dcbad593cf83a5@mail.gmail.com> <20070314122453.GA5775@elte.hu> <m1ejnsq789.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ejnsq789.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> However it has always been a bug for anything under /proc/sys to not 
> be a sysctl. It's not subtle breakage but subtle enforcement of the 
> existing rules.

it wasnt really a bug but an uncleanliness - but yeah. The way i used it 
is pretty much equivalent to a CTL_UNNUMBERED entry.

> [...]  It may be worth adding a test to create_proc_entry that says 
> "you silly person you need to use sysctls to create an entry under 
> /proc/sys"

yep, agreed - without the "silly person" bit ;-) It was a whole lot 
simpler in code to just add in a simple proc entry than a full sysctl 
table that i used for nothing. (because the sysctl wasnt really 
syscall-settable)

	Ingo
