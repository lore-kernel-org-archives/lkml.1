Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXLNT5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXLNT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXLNT5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:57:39 -0500
Received: from www.tglx.de ([62.245.132.106]:42606 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbXLNT5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:57:38 -0500
Date: Fri, 14 Dec 2007 20:57:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
In-Reply-To: <20071214181233.GB16351@one.firstfloor.org>
Message-ID: <alpine.LFD.0.99999.0712142053400.3668@localhost.localdomain>
References: <20071214004442.5f9eba88@linux360.ro> <p737ijigr8c.fsf@bingen.suse.de> <20071214143941.2c7dcfb4@linux360.ro> <20071214101720.GA10981@one.firstfloor.org> <20071214154106.4f0b2d8c@linux360.ro> <20071214122048.GA12550@one.firstfloor.org>
 <20071214180119.4c492f6c@linux360.ro> <alpine.LFD.0.99999.0712141835510.3668@localhost.localdomain> <20071214181233.GB16351@one.firstfloor.org>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Andi Kleen wrote:

> > magically in the SMM code. To work around this is we would need to add
> > the broadcast notification to the halt(), safe_halt(), pm_idle_halt()
> > variants which float around in the kernel and make this conditional on
> > the C1E detection. That's nasty, but it seems the only solution for
> > now.
> 
> On 64bit it would be easy using the idle notifiers. Perhaps they need
> to be extended to pass in the sleep state though.

Well, that would interfere with the acpi-idle code.

Anyway the idle notifiers is a pretty artificial interface which is on
my get rid of it list anyway.

Thanks,

	tglx

