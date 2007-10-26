Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXJZVfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXJZVfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763194AbXJZVfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:35:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759587AbXJZVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:35:37 -0400
Date: Fri, 26 Oct 2007 14:35:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
Message-Id: <20071026143525.b9218ed7.akpm@linux-foundation.org>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
References: <20071019075443.GA6407@havoc.gtf.org>
	<20071019075808.GH6407@havoc.gtf.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 09:00:23 -0400
"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> ACK with comment ...

Please don't top-post and then include 65 kbytes of unneeded goop.

> This API changed in 2.4.23 switching to irqreturn_t, and 2.6.19 dropping
> the struct_pt_regs argument, this is yet another API change in the same
> function. The last one came with no clues to differentiate except kernel
> version (for those of us that are required to produce updated
> back-ported driver modules once this patch becomes a legacy). I am
> *praying* that this API change is clean across 2.6.24 and add my voice
> to all to ACK this clearly!
> 

That was a goofup.  I proposed that we should add a #define
TWO_ARG_IRQ_HANDLERS (or whatever) and I think I actually wrote the patch,
but it got lost.

I agree it would be a kind thing to do in this case.

Not that I ever want to see these patches again ;)
