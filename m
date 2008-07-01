Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYGAIrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYGAIrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYGAIrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:47:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44007 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYGAIrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:47:13 -0400
Date: Tue, 1 Jul 2008 10:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
	systems
Message-ID: <20080701084648.GA21727@elte.hu>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080701001727.GA4174@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701001727.GA4174@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Assuming it works for Rafael (still haven't had time to pull my nx6125 
> out of storage):
> 
> Signed-off-by: mjg@redhat.com

Rafael, could you please try the latest tip/master that i've just pushed 
out:

  http://people.redhat.com/mingo/tip.git/README

it has the final form of these changes integrated - it should in theory 
work out of box on your system, with no boot parameters or other 
explicit quirks needed anywhere.

	Ingo
