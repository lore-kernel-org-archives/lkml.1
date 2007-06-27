Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbXF0Uca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbXF0Uca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbXF0UcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:32:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:41452 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXF0UcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:32:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bqtw+4qioAaOpsBy2xkg35FGjoerl8gi61GIQ3q39VAyC6MXEEGexwLEK6+70zxXOAUOm+N7v5zZdJbqx0/uGGja/DFfvxle4W6KB2xn8Ra3Mp9YyBxLTtHe5T4Pmq2l9xSdYN4wGqpEGgrrmezdH+bPP4dl1WLJ24cB8g7JMdk=
Message-ID: <86802c440706271332k78fe230cg425796e108ccb76b@mail.gmail.com>
Date: Wed, 27 Jun 2007 13:32:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: [PATCH] x86_64: change _map_single to static in pci_gart.c etc
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070627203023.GD4344@rhun.congress.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706271041.21937.yinghai.lu@sun.com>
	 <20070627202110.GA4344@rhun.congress.lan>
	 <20070627203023.GD4344@rhun.congress.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Wed, Jun 27, 2007 at 04:21:10PM -0400, Muli Ben-Yehuda wrote:
> > On Wed, Jun 27, 2007 at 10:41:21AM -0700, Yinghai Lu wrote:
> > > [PATCH] x86_64: change _map_single to static in pci_gart.c etc
> > >
> > > there function is called via dma_ops->.., so change it to static
> >
> > Thanks, mostly looks good - will verify and push via the next set of
> > Calgary updates.
>
> Sorry, should've read the patch more carefully - above applies to
> Calgary bits only.

 arch/x86_64/kernel/pci-calgary.c |    8 ++++----
 arch/x86_64/kernel/pci-gart.c    |    6 +++---
 arch/x86_64/kernel/pci-nommu.c   |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-

YH
