Return-Path: <linux-kernel-owner+w=401wt.eu-S1945977AbXBPQSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945977AbXBPQSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945978AbXBPQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:18:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:56121 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1945977AbXBPQSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:18:21 -0500
X-Provags-ID: V01U2FsdGVkX19o/EJ05t1orCGYv80DdfGKbISoXg1vwnSXKEM+0r
	EtJA==
From: Florian Schmidt <mista.tapas@gmx.net>
To: Mike Panetta <m.panetta@wegener.com>
Subject: Re: APIC priorities, can they be changed?
Date: Fri, 16 Feb 2007 17:18:23 +0100
User-Agent: KMail/1.9.6
Cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
References: <45D4A692.7090108@wegener.com> <fc.3b9aca006fe2a09c3b9aca00cb2296f3.fc598b@wegener.com> <45D4BB12.1050205@wegener.com>
In-Reply-To: <45D4BB12.1050205@wegener.com>
X-Face: %EpW[IH18fBP*R?oz~]%Klbl.q!_(Xs_q"t?K~RVx[c7~3|C3kDdA(8y_KOB\{(Rn(=?utf-8?q?MZhm=0A=09=7B/l=2E?=>O48>i9k<+(,c^Y%mGm)M\+RxuxL4r<7-W63sB$+w\}hkT"Q2?v&N:y\Z
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702161718.23806.mista.tapas@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007, Mike Panetta wrote:
> I did try that.  The BIOS only allows me to either allocate an IRQ to be
> a PCI interrupt, or reserve it (for what I have no idea).  The IRQ's
> listed in the BIOS are also different from the ones Linux sees.  I think
> the BIOS is seeing the XT-PIC IRQ numbers and Linux is seeing the APIC
> numbers.  For example the little bios blurb that prints before the
> system boots says the USB controller I am interested in is
> assigned/using IRQ 10, Linux sees it using IRQ 18.
>
> I have found that I can keep Linux from using the APIC by disabling it
> with a kernel command line switch, but that does not help, it just makes
> Linux use the XT-PIC instead of the IO-APIC to do IRQ routing.
>
> So I guess I'm back to my original question of  'Would changing the
> vector numbers do what I want?' and if the answer is 'yes', how would I
> do it?

With XT-PIC, there was a way to change the priotrities used by the IRQ. It was 
called irqtune iirc.

Ah ya,

http://cae.best.vwh.net/irqtune/

Dunno if there's something similar available for APIC..

Regards,
Flo

-- 
Palimm Palimm!
http://tapas.affenbande.org
