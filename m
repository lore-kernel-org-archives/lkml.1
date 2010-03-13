Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab0CMH2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 02:28:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab0CMH2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 02:28:03 -0500
Date: Sat, 13 Mar 2010 08:27:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Dieter Ries <mail@dieterries.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip 1/3] kprobes: Hide CONFIG_OPTPROBES and set if arch
 support optimized kprobes
Message-ID: <20100313072738.GB4892@elte.hu>
References: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312232208.2017.55337.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

>  config OPTPROBES
> -	bool "Kprobes jump optimization support (EXPERIMENTAL)"
> -	default y
> -	depends on KPROBES
> +	def_bool y
> +	depends on KPROBES && HAVE_OPTPROBES
>  	depends on !PREEMPT
> -	depends on HAVE_OPTPROBES
>  	select KALLSYMS_ALL
>  	help
>  	  This option will allow kprobes to optimize breakpoint to

The help text can be removed too, now that it's not interactive. Also, i'd 
suggest to add a comment that this just relays HAVE_OPTPROBES now, set by the 
arch.

	Ingo
