Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbZBDAri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbZBDAri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZBDAr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:47:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZBDAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:47:29 -0500
Date: Tue, 3 Feb 2009 16:46:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <200902040025.28254.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902031644290.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902032344.22348.rjw@sisk.pl> <1233702327.16867.109.camel@pasglop> <200902040025.28254.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> 
> I realize the problem, but IMO only a few drivers will be affected, since only
> a few of them implement suspend_late/resume_early.

Also, since we are fixing the irq issues and the basic PCI suspend/resume 
logic to be handled by the generic code, I suspect a lot of the drivers 
that _do_ the late/early stuff will be happy to simply get rid of them. 

			Linus
