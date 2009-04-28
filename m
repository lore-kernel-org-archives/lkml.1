Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZD1Qaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZD1Qaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZD1Qan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:30:43 -0400
Received: from outbound-mail-311.bluehost.com ([67.222.54.4]:53866 "HELO
	outbound-mail-311.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755268AbZD1Qam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:30:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AsCtahkZGEOK8gJEb0DRahyHQeUiyLT53DObvqcBpu6afcw4ztRJnx7wce2fZGCOEJCTpUqj6BAV6oA7tDlIqK1qqjQK0RUCL9hI8hcmC+ec6IOLnQFSpRRxNbX8WCCQ;
Date: Tue, 28 Apr 2009 09:28:50 -0700
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
Message-ID: <20090428092850.7f1559c9@hobbes>
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

Oh sorry meant to add:
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
