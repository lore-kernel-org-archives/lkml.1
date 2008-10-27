Return-Path: <linux-kernel-owner+w=401wt.eu-S1752322AbYJ0Rp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbYJ0Rp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 13:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYJ0Rpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 13:45:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44646 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYJ0Rpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 13:45:49 -0400
Date: Mon, 27 Oct 2008 18:45:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2] IOAPIC NMI watchdog fixes
Message-ID: <20081027174534.GA3046@elte.hu>
References: <20081027164233.132189000@napanee.usersys.redhat.com> <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Mon, 27 Oct 2008, Aristeu Rozanski wrote:
> 
> > These two patches make use of __acpi_nmi_disable() to make possible to:
> > - enable and disable IOAPIC NMI watchdog using procfs
> > - disable NMI generation if the NMI watchdog is not working on boot time
> 
>  Thanks, I'll see if I can find some time soon to give them a hit -- 
> I've got a serial console on my laptop now, :) so any odd boot-time 
> tests will be easier for me.  These would be best tested with Ingo's 
> APIC tree, a current snapshot of which I may not have handy.  Ping 
> me if I don't respond within a few days.

okay - they look reasonable so i've applied Aristeu's patches to 
tip/x86/apic and integrated them into tip/master, we'll see how they 
work out.

Please Ack/Nak them once you have the time to have a close look.

	Ingo
