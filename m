Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYHOOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYHOOlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbYHOOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:41:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48788 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYHOOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:41:36 -0400
Date: Fri, 15 Aug 2008 16:41:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Sven Wegener <sven.wegener@stealer.net>,
       LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] x86, acpi: temp_stack is used only when CONFIG_SMP is
	set
Message-ID: <20080815144117.GH12954@elte.hu>
References: <20080803165210.GC5414@joi> <alpine.LNX.1.10.0808031901120.7765@titan.stealer.net> <20080803172535.GE5414@joi> <20080807081245.GA1647@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807081245.GA1647@elf.ucw.cz>
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


* Pavel Machek <pavel@suse.cz> wrote:

> > > Now it still generates the warning, but on i386 with CONFIG_SMP set, 
> > > instead of x86_64 without CONFIG_SMP. We only need temp_stack, when both 
> > > CONFIG_64BIT and CONFIG_SMP are activated.
> > 
> > Yes. Thanks for looking at the patch!

> Acked-by: Pavel Machek <pavel@suse.cz>
> 
> Ingo, can you merge this one?

applied to tip/x86/urgent - thanks.

	Ingo
