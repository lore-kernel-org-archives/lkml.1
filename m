Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbYFZIwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbYFZIwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFZIw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:52:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYFZIw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:52:26 -0400
Date: Thu, 26 Jun 2008 10:51:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86 ACPI: normalize segment descriptor register on
	resume
Message-ID: <20080626085110.GA18599@elte.hu>
References: <200806242303.49498.rjw@sisk.pl> <20080626011716.e8c412dd.akpm@linux-foundation.org> <20080626082943.GC10973@elte.hu> <200806261040.00646.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806261040.00646.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Thursday, 26 of June 2008, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Len seems to think that Rafael seems to think that Ingo seems to think 
> > > that this patch broke one of his boxes.
> > > 
> > > Is it so?
> > 
> > No! :-)
> > 
> > it found a pre-existing suspend+resume breakage on a testbox. (I.e. 
> > the debug patch worked as i'd expect it to work. Every good debug 
> > patch starts its lifetime with a sharp spike of breakages it finds.)
> 
> Does it mean that the $subject patch doesn't break your test box after 
> all?

it doesnt break it - i get the same suspend+resume breakage without that 
patch as well, if i do it manually.

	Ingo
