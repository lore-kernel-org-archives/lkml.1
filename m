Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbYCFRta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbYCFRta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYCFRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:49:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56356 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYCFRtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:49:20 -0500
Date: Thu, 6 Mar 2008 18:49:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Miguel Boton <mboton.lkml@gmail.com>
Subject: Re: mach_reboot_fixups()
Message-ID: <20080306174858.GA31360@elte.hu>
References: <47D031CD.76E4.0078.0@novell.com> <20080306174311.GA23029@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306174311.GA23029@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0069]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Can you see any other material difference due to the unification? 
> reboot_mode is now written to 0x472 unconditionally, but we can 
> consider that a bugfix. Otherwise the mode and ordering of reboot 
> sequences seems to be equivalent to me.

btw., i removed mach_reboot.h as well in x86.git - it's now unused.

	Ingo
