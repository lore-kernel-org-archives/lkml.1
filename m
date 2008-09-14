Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYINQKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYINQKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYINQKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:10:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbYINQKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:10:42 -0400
Date: Sun, 14 Sep 2008 18:10:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex Nixon <alex.nixon@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86/paravirt: Remove duplicate
	paravirt_pagetable_setup_{start,done}()
Message-ID: <20080914161025.GA22385@elte.hu>
References: <1220449000-15264-1-git-send-email-alex.nixon@citrix.com> <20080905154655.GH10292@elte.hu> <48CADCD2.3000406@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CADCD2.3000406@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > * Alex Nixon <alex.nixon@citrix.com> wrote:
> >
> >   
> >> They were already called once in arch/x86/kernel/setup.c - we don't need to call them again.
> >>
> >> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
> >> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >>     
> >
> > applied to tip/x86/paravirt - thanks.
> >   
> 
> This fixes a regression in -rc, so it should probably go to Linus.  See
> http://bugzilla.kernel.org/show_bug.cgi?id=11485

ok, i've cherry-picked it over into tip/x86/urgent.

Thanks,

	Ingo
