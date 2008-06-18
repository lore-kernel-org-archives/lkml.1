Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYFRPat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYFRPat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 11:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbYFRPaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 11:30:39 -0400
Received: from www.tglx.de ([62.245.132.106]:46667 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYFRPah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:30:37 -0400
Date: Wed, 18 Jun 2008 17:29:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806181640.45595.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0806181726400.3395@apollo.tec.linutronix.de>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <alpine.LFD.1.10.0806181000440.3395@apollo.tec.linutronix.de> <alpine.LFD.1.10.0806181421320.3395@apollo.tec.linutronix.de> <200806181640.45595.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:
> > I just checked that the original c1e series and the affected code in
> > tip are not different. IIRC you confirmed that the C1E patches would
> > work on your box. So I wonder what else got changed which causes these
> > problems.
> 
> Well, to eliminate any possible correlations, do you have a version of the
> series or a single patch against the current mainline?

http://userweb.kernel.org/~tglx/952f4a-c1e-apic.patch
http://userweb.kernel.org/~tglx/952f4a-c1e.patch

c1e-apic is the forward port of the apic changes and c1e is the pure
c1e stuff. On my box it does not work w/o the c1e-apic one, but ....

Thanks,
	tglx
