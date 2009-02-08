Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZBHXJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZBHXJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZBHXJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:09:27 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:55167 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZBHXJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:09:27 -0500
Date: Sun, 8 Feb 2009 16:09:10 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Ingo Molnar <mingo@elte.hu>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/irq: fix sparse warning: make symbol static
Message-ID: <20090208230910.GH31509@parisc-linux.org>
References: <20090208192405.8084.89231.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208192405.8084.89231.stgit@vmbox.hanneseder.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:24:47PM +0100, Hannes Eder wrote:
> -static inline int do_irq_select_affinity(int irq, struct irq_desc *desc)
> +static inline int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)

Does this not introduce a checkpatch warning about a line being longer
than 80 columns?  Three acceptable ways to fix this:

static inline
int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)

static inline int do_irq_select_affinity(unsigned int irq,
							struct irq_desc *desc)

static inline int do_irq_select_affinity(unsigned irq, struct irq_desc *desc)

My favourite is the last one.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
