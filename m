Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZJ1WXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZJ1WXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZJ1WXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:23:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44304 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753697AbZJ1WXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:23:33 -0400
Date: Wed, 28 Oct 2009 22:24:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Igor Chudov <ichudov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading on 4 core CPU DECREASES performance???
Message-ID: <20091028222439.3e0be650@lxorguk.ukuu.org.uk>
In-Reply-To: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
References: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is Ubuntu Hardy, 2.6.24 kernel. I tried the same with 2.6.31,
> with the same effect.
> 
> This article from Intel:
> 
> http://software.intel.com/sites/oss/pdfs/mclinux.pdf
> 
> It talks about intelligent handling of multiple cores as a done deal,
> but in my experience that did not actually occur.
> 
> I would like to know how can I make the scheduler to prefer to spread
> the tasks across physical cores as opposed to bundling two on one core
> and leaving some cores idle.

The scheduler will try and do balancing for packages and for HT. Make
sure your distribution is built with the SCHED_SMT and SCHED_MC options
enabled. Some of the non-enterprise distirbutions may well not have these
enabled.

For hand laying out threads see: man pthread_setaffinity_np

The win from HT depends a lot on the CPU and also the workload mix. In
some workloads it will decrease performance.



