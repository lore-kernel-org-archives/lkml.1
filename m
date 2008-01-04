Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYADI7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYADI7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 03:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYADI6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 03:58:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60316 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbYADI6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 03:58:54 -0500
Date: Fri, 4 Jan 2008 09:58:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [4/16] Add /proc/irq/*/spurious to dump the
	spurious irq debugging state
Message-ID: <20080104085845.GD28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154217.E57A714DDB@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154217.E57A714DDB@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> This is useful to debug problems with interrupt handlers that return 
> sometimes IRQ_NONE.

agreed.

A style error slipped in, please fix it:

> +static int irq_spurious_read(char *page, char **start, off_t off,
> +				  int count, int *eof, void *data)
> +{
> +	struct irq_desc *d = &irq_desc[(long) data];
> +	return sprintf(page, "count %u\n"
> +			     "unhandled %u\n"

	Ingo
