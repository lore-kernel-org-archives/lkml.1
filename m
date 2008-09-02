Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYIBMWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYIBMWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIBMWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:22:25 -0400
Received: from www.tglx.de ([62.245.132.106]:49543 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYIBMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:22:25 -0400
Date: Tue, 2 Sep 2008 14:21:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <87k5dvvysd.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0809021419490.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011500460.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033060.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011545020.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809020117260.3243@apollo.tec.linutronix.de> <87k5dvvysd.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Andi Kleen wrote:

> Thomas Gleixner <tglx@linutronix.de> writes:
> >
> > The whole ACPI code relies pretty much on PM_TIMER and as I said
> 
> The Linux ACPI code does not rely on PM_TIMER in any special ways AFAIK 
> (except that it occasionally uses standard linux timer functions)
> It merely discovers it for use by the other pmtimer users.

# grep -rc acpi_gbl_FADT.xpm_timer_block.address drivers/acpi/ | grep -v ":0"
drivers/acpi/processor_idle.c:12

I need to correct myself. It's only the processor_idle code :)

Thanks,

	tglx
