Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZI1PgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZI1PgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZI1PgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:36:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZI1PgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:36:01 -0400
Date: Mon, 28 Sep 2009 17:35:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] thinkpad-acpi: Fix build
	on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL
Message-ID: <20090928153526.GA9231@elte.hu>
References: <200909260519.n8Q5JrB6016778@hera.kernel.org> <20090927075254.GA20847@elte.hu> <20090927122828.GA24783@khazad-dum.debian.net> <alpine.LFD.2.00.0909272331520.5561@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0909272331520.5561@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

* Len Brown <lenb@kernel.org> wrote:

> 
> > > >  drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
> > > 
> > > -tip testing found that these changes caused a build failure 
> > > in drivers/platform/x86/thinkpad_acpi.c when 
> > > !CONFIG_THINKPAD_ACPI_HOTKEY_POLL - the fix is attached  below.
> > 
> > Fixed by a different patch, which will hit mainline soon....
> 
> Ingo,
> 2.6.32-rc1 should build fine* -- let me know if it doesn't.
> 
> thanks,
> Len Brown, Intel Open Source Technology Center
> 
> * module this message, which Henruque assures me will go away soon
> drivers/platform/x86/thinkpad_acpi.c:2225: warning: 
> ‘tpacpi_hotkey_driver_mask_set’ defined but not used

well, the warning is fixed properly in my patch, as pointed out in the 
changelog. Have you read that?

	Ingo
