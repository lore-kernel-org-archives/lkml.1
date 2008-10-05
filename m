Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYJEJ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYJEJ4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYJEJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:56:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJEJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:56:08 -0400
Date: Sun, 5 Oct 2008 11:55:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       alan-jenkins@tuffmail.co.uk
Subject: Re: [PATCH -tip] Fastboot: fix initcalls disposition in
	bootgraph.pl
Message-ID: <20081005095559.GE29909@elte.hu>
References: <48E7C594.4030400@gmail.com> <20081004131901.66720416@infradead.org> <c62985530810041328i282818cak8cd0ba36c450e3d6@mail.gmail.com> <20081004133940.44feb2a0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081004133940.44feb2a0@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sat, 4 Oct 2008 22:28:49 +0200
> "Frédéric Weisbecker" <fweisbec@gmail.com> wrote:
> 
> > I'm tracing all of the initcalls in my machine (even the modules).
> > If you look at both svg sources, you will see all of the 5 initcalls
> > displayed. But for the "before the patch" one, it depends on the
> > software you are using to visualize it.
> > With firefox you only see two of them. With the default gnome
> > visualization software (don't remember its name)
> > you can see all of them but in a very extensive image because a lot of
> > rows are unused.
> > 
> > With the "after the patch one", there is no issues....
> 
> fair enough
> 
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

applied to tip/tracing/core, thanks!

Frédéric, is the revert still needed, or is latest tip/master OK ?

	Ingo
