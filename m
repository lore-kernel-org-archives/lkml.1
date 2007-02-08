Return-Path: <linux-kernel-owner+w=401wt.eu-S1422964AbXBHMh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422964AbXBHMh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422744AbXBHMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:37:27 -0500
Received: from brick.kernel.dk ([62.242.22.158]:11032 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422969AbXBHMh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:37:27 -0500
Date: Thu, 8 Feb 2007 13:40:03 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Otavio Salvador <otavio@debian.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add PM_TRACE x86_64 support.
Message-ID: <20070208124003.GE4487@kernel.dk>
References: <1170895857.4451.55.camel@nigel.suspend2.net> <87lkj9bg67.fsf@neumann.lab.ossystems.com.br> <1170900487.4451.62.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170900487.4451.62.camel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08 2007, Nigel Cunningham wrote:
> On Wed, 2007-02-07 at 23:18 -0200, Otavio Salvador wrote:
> > Nigel Cunningham <nigel@nigel.suspend2.net> writes:
> > 
> > > -	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 6) {
> > > +	for (tracedata = &__tracedata_start ; tracedata < &__tracedata_end ; tracedata += 2 + sizeof(unsigned long)) {
> > 
> > Could you split this line?
> 
> Sure.
> 
> -- New version -- (What's the right way to do this?)
> 
> This patch add x86_64 support for PM_TRACE, and shifts per-arch code to
> the appropriate subdirectories.
> 
> Symbol exports are added so tracing can be used from drivers built as
> modules too.

Don't include exports in a patch that doesn't use them. Introduce the
exports in a later patch series, for when you actually need it.

-- 
Jens Axboe

