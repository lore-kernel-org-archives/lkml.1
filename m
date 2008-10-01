Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYJAARe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYJAARe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 20:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYJAAR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 20:17:26 -0400
Received: from xenotime.net ([66.160.160.81]:42984 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753466AbYJAARZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 20:17:25 -0400
Date: Tue, 30 Sep 2008 17:35:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Message-Id: <20080930173546.2c226fd3.rdunlap@xenotime.net>
In-Reply-To: <86802c440809301659h4ff57a32r28e62b32386752e9@mail.gmail.com>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	<20080930165739.7847be37.rdunlap@xenotime.net>
	<48E2B920.2020503@zytor.com>
	<86802c440809301652o72e2a54lf38dae39c59e4d51@mail.gmail.com>
	<86802c440809301659h4ff57a32r28e62b32386752e9@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 16:59:49 -0700 Yinghai Lu wrote:

> On Tue, Sep 30, 2008 at 4:52 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, Sep 30, 2008 at 4:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> Randy Dunlap wrote:
> >>>
> >>> E.g., the "apic" entries are not grouped together and these mtrr entries
> >>> should
> >>> not be grouped together unless they all begin with "mtrr", which is an
> >>> option here:
> >>> they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
> >>> And "disable_mtrr_trim" could be renamed to "mtrr-notrim".
> >>>
> >>
> >> That does collide with the (not always kept) convention of prefixing "no" to
> >> disable a boolean option, though.
> >>
> >
> > it seems should group them and then provide one index section...
> >
> or
> 1. put all description in .c files
> 2. have one scripts to search early_param and __setup and create that
> kernel_parameter...

Until that's done, please keep them in alpha order, like they (mostly)
are now.


---
~Randy
