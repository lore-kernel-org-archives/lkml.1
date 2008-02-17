Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYBQRHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYBQRHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYBQRHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:07:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56949 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYBQRHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:07:23 -0500
Date: Sun, 17 Feb 2008 18:07:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86: apic: Extended interrupt LVT support for AMD
	Barcelona (32bit)
Message-ID: <20080217170707.GO6006@elte.hu>
References: <20080213151811.804698000@amd.com> <20080213151841.586864000@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213151841.586864000@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

>  /*
> + * Setup extended LVT, AMD specific (K8, family 10h)
> + *
> + * Vector mappings are hard coded. On K8 only offset 0 (APIC500) and
> + * MCE interrupts are supported. Thus MCE offset must be set to 0.
> + */

thanks, applied.

	Ingo
