Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXJBFCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXJBFCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXJBFCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:02:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXJBFCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:02:19 -0400
Date: Mon, 1 Oct 2007 22:00:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mika =?UTF-8?B?UGVudHRpbMOk?= <mika.penttila@kolumbus.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       David Bahi <dbahi@novell.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Message-ID: <20071001220022.5c9b9bef@laptopd505.fenrus.org>
In-Reply-To: <4701CF78.5020802@kolumbus.fi>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
	<200710012341.53169.ak@suse.de>
	<alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain>
	<200710020007.09864.ak@suse.de>
	<alpine.LFD.0.9999.0710020043450.20478@localhost.localdomain>
	<4701CF78.5020802@kolumbus.fi>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Oct 2007 07:56:24 +0300
Mika Penttilä <mika.penttila@kolumbus.fi> wrote:


> Here I have with stock FC7 (2.6.22.9-91) kernel :
>  0:     107835  133459760   IO-APIC-edge      timer
> 


fwiw this is entirely done by the hardware; no irq balancer has touched
this one (fc7 has the new irqbalancer which leaves irq0 alone)
