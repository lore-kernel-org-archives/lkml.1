Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbYB2TSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbYB2TSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYB2TSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:18:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYB2TSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:18:05 -0500
Date: Fri, 29 Feb 2008 20:17:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86 pci: remove checking type for mmconfig probe v2
Message-ID: <20080229191745.GA19476@elte.hu>
References: <200802271639.52958.yinghai.lu@sun.com> <200802282356.50496.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802282356.50496.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> doesn't need to check if it is type1 or type2. we can use raw_pci_ops 
> dirctly.
> 
> also make pci_direct_conf1 static again.
> 
> anyway is there system with type 2 and mmconf support?

i've picked it up into x86.git#testing so it gets test coverage, but it 
would be nice to hear what Greg and the other PCI folks think about 
this.

	Ingo
