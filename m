Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYBSJNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYBSJNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYBSJMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:12:51 -0500
Received: from www.tglx.de ([62.245.132.106]:48371 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbYBSJMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:12:49 -0500
Date: Tue, 19 Feb 2008 10:12:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: RE: [BUG][RFC] [GENERIC IRQ] irq_chip_set_defaults shutdown /
 disable
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC125CC945@limkexm2.ad.analog.com>
Message-ID: <alpine.LFD.1.00.0802191011430.7583@apollo.tec.linutronix.de>
References: <600D5CB4DFD93545BF61FF01473D11AC125CC945@limkexm2.ad.analog.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Hennerich, Michael wrote:
> >Can you please confirm, whether my version of the fix works for you as
> >well.
> >
> >Thanks,
> >
> >	tglx
> 
> Thomas,
> 
> Works - no problems.
> There was another typo 
> 
> >+			chip_disable : default_shutdown;
> Should be better:
> +                       chip->disable : default_shutdown;

Noticed when I tested it myself :(
 
Thanks,

	tglx
