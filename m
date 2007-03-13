Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbXCMKu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbXCMKu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXCMKu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:50:27 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:38924
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbXCMKu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:50:26 -0400
Date: Tue, 13 Mar 2007 03:50:13 -0700
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313105012.GA5608@gnuppy.monkey.org>
References: <200703111457.17624.kernel@kolivas.org> <200703132021.50712.kernel@kolivas.org> <20070313092920.GB7648@elte.hu> <200703132041.06320.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703132041.06320.kernel@kolivas.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 08:41:05PM +1100, Con Kolivas wrote:
> On Tuesday 13 March 2007 20:29, Ingo Molnar wrote:
> > So the question is: if all tasks are on the same nice level, how does,
> > in Mike's test scenario, RSDL behave relative to the current
> > interactivity code?
... 
> The only way to get the same behaviour on RSDL without hacking an 
> interactivity estimator, priority boost cpu misproportionator onto it is to 
> either -nice X or +nice lame.

Hello Ingo,

After talking to Con over IRC (and if I can summarize it), he's wondering if
properly nicing those tasks, as previously mention in user emails, would solve
this potential user reported regression or is something additional needed. It
seems like folks are happy with the results once the nice tweeking is done.
This is a huge behavior change after all to scheduler (just thinking out loud).

bill

