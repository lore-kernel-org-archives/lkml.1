Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZD3TLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZD3TLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZD3TLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:11:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59194 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZD3TLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:11:41 -0400
Date: Thu, 30 Apr 2009 21:10:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/7] kconfig: more featured minimum module configs
Message-ID: <20090430191001.GA14108@elte.hu>
References: <20090430185022.122124349@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430185022.122124349@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This set of patches adds on top of my previous post.
> 
> It fixes CONFIG_IKCONFIG when CONFIG_IKCONFIG_PROC is not set.
>  (gcc optimizes the config out!)
> 
> As a request from Ingo, it now enables IKCONFIG and will also use 
> various locations to find a config to base against.

hm, now 'make localyesconfig' done on a Fedora distro kernel 
produces something very close to an allyesconfig:

 -rw-rw-r-- 1 mingo mingo 91930 2009-04-30 20:03 .config
 aldebaran:~/linux/linux> grep =y .config | wc -l
 3398

is that expected?

	Ingo
