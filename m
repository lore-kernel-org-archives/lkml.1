Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbXJAWJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbXJAWJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbXJAWIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:08:54 -0400
Received: from ns.suse.de ([195.135.220.2]:41414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbXJAWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:08:53 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Date: Tue, 2 Oct 2007 00:07:09 +0200
User-Agent: KMail/1.9.1
Cc: Arjan van de Ven <arjan@infradead.org>, David Bahi <dbahi@novell.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <GHaskins@novell.com>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710012341.53169.ak@suse.de> <alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710012349160.20478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710020007.09864.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OTOH, the accounting hook would allow us to remove the IRQ#0 -> CPU#0
> restriction. Not sure whether it's worth the trouble.

Some SIS chipsets hang the machine when you migrate irq 0 to another
CPU. It's better to keep that Also I wouldn't be surprised if there are some
other assumptions about this elsewhere.

Ok in theory it could be done only on SIS, but that probably would really
not be worth the trouble

-Andi
