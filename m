Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZD2IP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZD2IP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZD2IPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:15:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44458 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD2IPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:15:07 -0400
Date: Wed, 29 Apr 2009 10:14:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/13] x86, vmlinux.lds: unify header/footer
Message-ID: <20090429081459.GA9369@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <1240991249-27117-2-git-send-email-sam@ravnborg.org> <20090429080455.GE22129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429080455.GE22129@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Merge everything except PHDRS and SECTIONS into
> > vmlinux.lds.S
> > No functional changes.
> > 
> > This include the removal of an ancient comment that
> > Martin Mares wrote this file.
> 
> > -/* ld script to make i386 Linux 
> > - * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
> 
> That's a historic copyright notice in essence which we should not 
> remove - we should preserve that as:
> 
> > + Original 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> 
> (preferably with a date-of-that-original-patch inserted as well)

I've added these credits:

+/*
+ * ld script for the x86 kernel
+ *
+ * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *
+ * Modernisation and unification done by Sam Ravnborg <sam@ravnborg.org>

is that fine to you?

	Ingo
