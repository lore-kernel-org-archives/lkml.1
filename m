Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbZF2Tf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbZF2Tf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZF2TfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:35:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZF2TfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:35:11 -0400
Date: Mon, 29 Jun 2009 21:34:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: Corentin Chary <corentincj@iksaif.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH, v3] eeepc-laptop: Fix build failure with HOTPLUG_PCI
	&& !SYSFS (was: [git pull request] ACPI & driver patches for
	2.6.31-rc1)
Message-ID: <20090629193406.GA30774@elte.hu>
References: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain> <20090629080754.GA28336@elte.hu> <20090629081016.GA31398@elte.hu> <20090629081339.GA321@elte.hu> <alpine.LFD.2.00.0906291135550.5716@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906291135550.5716@localhost.localdomain>
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

> Thanks for fixing this config, Ingo.
> 
> I agree, our build system can handle "depends",
> but "select" does not deliver on what it advertises,
> making it a trap for programmers.

Hm, this portion of Kconfig is a trap in a way indeed - on the other 
hand it is also a useful tool and the simplistic approach to 
disallow select altogether is a step backwards.

IIRC either Vegard or Steve has come up with a patch series that 
improved Kconfig to warn about problem selects while still allowing 
the simple ones. That would deflect most of the bad uses while still 
allowing the good uses. Not sure what happened to that series.

	Ingo
