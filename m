Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYAHJq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYAHJq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYAHJqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:46:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYAHJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:46:49 -0500
Date: Tue, 8 Jan 2008 10:46:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] Re: Unify arch/x86/kernel/acpi/sleep*.c
Message-ID: <20080108094623.GH27671@elte.hu>
References: <20080107122305.GA11062@elf.ucw.cz> <200801071741.02577.rjw@sisk.pl> <200801080148.14208.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801080148.14208.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday, 7 of January 2008, Rafael J. Wysocki wrote:
> > On Monday, 7 of January 2008, Pavel Machek wrote:
> > > Unify arch/x86/kernel/acpi/sleep*.c
> > > 
> > > Pretty trivial unification; when two functions differed, it was
> > > usually in error handling, and better of the two was picked up.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > 
> > Looks-okay-to: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > > ---
> > > 
> > > (Seems to work on i386, but needs some x86-64 testing.)
> > 
> > I'll test it later today.
> 
> Tested, works.

thanks - i've picked up Pavel's patch for x86.git and have added:

 Looks-okay-to: Rafael J. Wysocki <rjw@sisk.pl>
 Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

Len, is this fine with you too, or do you have any outstanding 
fixes/changes in this area?

	Ingo
