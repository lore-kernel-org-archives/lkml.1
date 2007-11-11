Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXKKUbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXKKUbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXKKUbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:31:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54977 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192AbXKKUa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:30:59 -0500
Date: Sun, 11 Nov 2007 21:30:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Message-ID: <20071111203039.GA16925@elte.hu>
References: <200711112058.28043.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711112058.28043.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Subject		: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> References	: http://lkml.org/lkml/2007/11/2/165
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9297
> Handled-By	: Andrey Borzenkov <arvidjaar@mail.ru>
> 		  Ingo Molnar <mingo@elte.hu>
> Patch		: 
> Note		: goes away if ACPI_PROCFS is set

should be fixed by acpi-make-acpi_procfs-default-to-y.patch in -mm. (not 
yet upstream i think, but should before v2.6.24)

	Ingo
