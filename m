Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbXJGJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbXJGJDg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 05:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXJGJD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 05:03:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbXJGJDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 05:03:25 -0400
Date: Sun, 7 Oct 2007 11:03:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, Ayaz Abdulla <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] forcedeth: interrupt handling cleanup
Message-ID: <20071007090313.GA733@elte.hu>
References: <20071006151250.GA17020@havoc.gtf.org> <20071006151400.GB17488@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006151400.GB17488@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> -			spin_unlock(&np->lock);
> -			printk(KERN_DEBUG "%s: too many iterations (%d) in nv_nic_irq.\n", dev->name, i);
> -			break;

i like that! One forcedeth annoyance that triggers frequently on one of 
my testboxes is:

[  120.955202] eth0: too many iterations (6) in nv_nic_irq.
[  121.233865] eth0: too many iterations (6) in nv_nic_irq.
[  129.215450] eth0: too many iterations (6) in nv_nic_irq.
[  139.734408] eth0: too many iterations (6) in nv_nic_irq.
[  144.546811] eth0: too many iterations (6) in nv_nic_irq.
[  153.811005] eth0: too many iterations (6) in nv_nic_irq.
[  154.695879] eth0: too many iterations (6) in nv_nic_irq.
[  155.455078] eth0: too many iterations (6) in nv_nic_irq.
[  173.912162] eth0: too many iterations (6) in nv_nic_irq.

	Ingo
