Return-Path: <linux-kernel-owner+w=401wt.eu-S1762563AbZD1Q2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762563AbZD1Q2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbZD1Q2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:28:42 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:60114 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755683AbZD1Q2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:28:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bxvb3DDC4iJ5yqbB3FNNd+vUQ5CZPBLowueXTS3+FZJK9g9fnpSLfG1C7BKg7pAdpF12qC0wtZDAbxPKDNTM7GZUaTSBmhqDjDth7bOL85VZOjP+8L1c60v5oqYoLf3G;
Date: Tue, 28 Apr 2009 09:28:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] irq: make ht irq_desc numa aware
Message-ID: <20090428092835.3cc252d3@hobbes>
In-Reply-To: <20090428101917.GB28495@elte.hu>
References: <49E68C41.4020801@kernel.org>
	<20090416090315.GF9813@elte.hu>
	<49E802CE.5030406@kernel.org>
	<49E804D4.70009@kernel.org>
	<49F655B6.8020109@kernel.org>
	<20090428101917.GB28495@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 12:19:17 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Try to get irq_desc on the same node as create_irq_nr().
> >
> > [ Impact: optimization, make HT IRQs more NUMA-aware ]
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  drivers/pci/htirq.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Looks good - but this really needs an Ack from Jesse (Cc:-ed) before 
> we can pick it up into the irq tree.

Looks fine.  I had to look up what the first arg of create_irq_nr meant
(maybe we should have an IRQ_NR_ANY #define for that?), but otherwise
it looks fine.

-- 
Jesse Barnes, Intel Open Source Technology Center
