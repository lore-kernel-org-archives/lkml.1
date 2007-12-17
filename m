Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXLQNe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXLQNe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXLQNeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:34:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXLQNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:34:10 -0500
Date: Mon, 17 Dec 2007 14:33:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make __{save,restore}_processor_state static
Message-ID: <20071217133350.GF1870@elte.hu>
References: <47610C0C.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610C0C.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> .. allowing to remove their declarations from a global include file 
> (the symbols don't exist for anything but x86).
> 
> Likewise for 64-bits' fix_processor_context(), just that that one was 
> properly declared in an arch-specific header.

thanks, applied your patch to x86.git, for v2.6.25.

	Ingo
