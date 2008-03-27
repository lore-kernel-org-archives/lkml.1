Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYC0IqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYC0IqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYC0IqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:46:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57480 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYC0IqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:46:14 -0400
Date: Thu, 27 Mar 2008 09:45:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: add pci=skip_isa_align command lines.
Message-ID: <20080327084557.GH15626@elte.hu>
References: <200803270131.18885.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803270131.18885.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> [PATCH] x86/pci: add pci=skip_isa_align command lines.
> 
> so we don't align the io port start address for pci cards.
> 
> also move out dmi check out acpi.c, because it has nothing to do with 
> acpi. it could spare some calling when we have several peer root 
> buses.

i like this feature, and i've applied your patch to x86.git for testing, 
but i'd like to hear what the ACPI and PCI guys think about this.

Also, we should try as hard as possible to make it a blacklist instead 
of a whitelist? It would be cool to support more PCI cards/devices on 
all new(-ish) systems by default and if we didnt have to maintain the 
DMI whitelist for eternity. (a whitelist will always be incomplete and 
will lag behind reality)

	Ingo
