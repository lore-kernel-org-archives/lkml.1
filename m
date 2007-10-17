Return-Path: <linux-kernel-owner+w=401wt.eu-S936288AbXJQCgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936288AbXJQCgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbXJQCgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:36:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:42054 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbXJQCf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N2VtzVFtYfRSxaTR4jy1yb7Gq06qvVc57tMo8sp5p4k5XdkF6z2O1ZFGktuM+BMo3u/MtF0sihdd9iNXuaq4Dgz2V65tenVNCzD5sJ/s8ZBcFeLI1Na34J4HNq5eaBbX3iIDqZz8wdkIQOdgHuMnVys/HU9LLtaZKdgkwrBvzgQ=
Message-ID: <2cd57c900710161935l2121bffex78475ca33f0574ca@mail.gmail.com>
Date: Wed, 17 Oct 2007 10:35:58 +0800
From: "Qi Yong" <qiiyoong@gmail.com>
To: "Stefan Seyfried" <seife@suse.de>
Subject: Re: [PATCH] swsusp: Use platform mode by default
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alexey Starikovskiy" <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070514075045.GA10238@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200611011323.14830.rjw@sisk.pl> <200705111121.51704.rjw@sisk.pl>
	 <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org>
	 <200705112208.53971.rjw@sisk.pl>
	 <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
	 <20070514075045.GA10238@suse.de>
X-Google-Sender-Auth: edfa9a75e5cb87d2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/2007, Stefan Seyfried <seife@suse.de> wrote:
> On Fri, May 11, 2007 at 03:51:38PM -0700, Linus Torvalds wrote:
> >
> >
> > On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > >
> > > Just to clarify, the change in question isn't new.  It was introduced by the
> > > commit 9185cfa92507d07ac787bc73d06c42222eec7239 before 2.6.20, at Seife's
> > > request and with Pavel's acceptance.
> >
> > Ok, if it's that old, we migt as leave it in. Clearly there weren't many
> > regressions, and this isn't a case of other monsters lurking behind a lack
> > of testers.
>
> I pushed for this since on ACPI machines, "platform" is the right thing to do,
> and i still think it will only break on machines that have a broken ACPI BIOS.
> (Are there machines with broken ACPI BIOS around? ;-)
>
> Your additional "fall back to shutdown if !(ops)"-fix looks very sane,
> however, and is definitely a good idea.

The key point is "fall back to shutdown _only_ if !ops, otherwise
don't touch hibernation_mode". And that solves my problem.
-- 
Qi Yong
