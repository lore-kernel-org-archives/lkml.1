Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYCRLrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYCRLrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYCRLq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:46:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40422 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYCRLq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:46:56 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1205839660.8514.340.camel@twins> (message from Peter Zijlstra on
	Tue, 18 Mar 2008 12:27:40 +0100)
Subject: Re: [patch 1/8] mm: bdi: export bdi_writeout_inc()
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191941.332720129@szeredi.hu> <1205839660.8514.340.camel@twins>
Message-Id: <E1JbaHJ-0005hM-CW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 12:46:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +void bdi_writeout_inc(struct backing_dev_info *bdi)
> > +{
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	__bdi_writeout_inc(bdi);
> > +	local_irq_restore(flags);
> > +}
> > +EXPORT_SYMBOL(bdi_writeout_inc);
> > +
> 
> May I ask to make this a _GPL export, please? 

Sure.

Miklos
