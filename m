Return-Path: <linux-kernel-owner+w=401wt.eu-S935582AbYCDXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935582AbYCDXey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934973AbYCDXbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:31:42 -0500
Received: from cavan.codon.org.uk ([78.32.9.130]:40476 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbYCDXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:31:40 -0500
Date: Tue, 4 Mar 2008 23:30:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Klaus S. Madsen" <ksm@hjernemadsen.org>, Pavel Machek <pavel@ucw.cz>,
       Suspend-devel list <suspend-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Message-ID: <20080304233027.GA15302@srcf.ucam.org>
References: <47C873AA.6040305@zytor.com> <20080229212654.GL27212@elte.hu> <20080301094525.GQ17932@hjernemadsen.org> <20080303121735.GE28369@elf.ucw.cz> <20080303151155.GT17932@hjernemadsen.org> <20080303174858.GB25496@elte.hu> <20080303205227.GU17932@hjernemadsen.org> <20080304123602.GC29777@elte.hu> <47CDD480.7000802@goop.org> <47CDD715.3010905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDD715.3010905@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Regression in 2.6.25-rc3: s2ram segfaults before suspending
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 03:11:17PM -0800, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> >>
> >>PAE activates NX on 32-bit. So we probably had an NX regression that 
> >>got fixed by the side-effects of one of the unifications. Does it 
> >>start working if you disable NX via the noexec=off boot option?
> >
> >What's the state of play here?  Is upshot that this change fixed a bug 
> >which broke s2ram, or caused a bug which broke s2ram?
> >
> 
> As far as I can tell, this change fixed a bug, and the fact that the bug 
> was fixed triggered a s2ram bug.

Strictly a libx86 bug, so I'll try to get an updated version uploaded in 
the near future. This won't hit x86_64 users, since the code is run 
through x86emu rather than executed directly.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
