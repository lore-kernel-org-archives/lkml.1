Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZKEK6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZKEK6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZKEK6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:58:21 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:56128 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbZKEK6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:58:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19186.44983.543376.657628@pilspetsen.it.uu.se>
Date: Thu, 5 Nov 2009 11:57:59 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ingo Molnar <mingo@elte.hu>
Cc: Aristeu Rozanski <aris@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: introduce NMI_AUTO as nmi_watchdog option
In-Reply-To: <20091104155641.GA11444@elte.hu>
References: <20091103171054.GB25437@redhat.com>
	<20091104114630.GA16993@elte.hu>
	<20091104151929.GH18613@redhat.com>
	<20091104155641.GA11444@elte.hu>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:
 > > but that would work only for LAPIC. You're suggesting killing IOAPIC 
 > > mode too?
 > 
 > Would it be a big loss, with all modern systems expected to have a 
 > working lapic based NMI source?

The IOAPIC NMI uses a HW resource that is free and reliable, the LAPIC NMI
uses a HW resource that is neither free nor reliable (for that application),
and for which better applications exist. So I prefer the IOAPIC NMI.

(I admit part of that preference is because using the IOAPIC NMI helped
stabilize a Dell PE2650 here years ago. Without the IOAPIC NMI the machine
would lock up hard within days or a few weeks at the most.)
