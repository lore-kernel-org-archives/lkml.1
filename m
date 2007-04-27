Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXD0VQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXD0VQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757315AbXD0VQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:16:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:33499 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317AbXD0VQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:16:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ptvlHBBHlJzNAtaDAqe1nJqJjfeNAaWu9jL1D9HsBj/hCmBov9FeBy65puL+X755AHrgWx7DJ5Lqn/kcZ6rSZqfgNuc4bdNpI+xJyBrcSp2BLRHHAhov7eOOSJc0/CE+YkP2crC1l28PGwk/FXAdH4oQKVf8aI98hIvVkhsbZxw=
Message-ID: <75b66ecd0704271416v535390b6t5d2d5677547b3ba2@mail.gmail.com>
Date: Fri, 27 Apr 2007 17:16:53 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v6
Cc: "Kasper Sandberg" <lkml@metanurb.dk>,
       "Gene Heskett" <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Con Kolivas" <kernel@kolivas.org>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Willy Tarreau" <w@1wt.eu>, "Mark Lord" <lkml@rtr.ca>,
       "Zach Carter" <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070427130234.GA16558@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427130234.GA16558@elte.hu>
X-Google-Sender-Auth: 67dc1f1a7f0a4e0c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/07, Ingo Molnar <mingo@elte.hu> wrote:
> ogg123 never skips. Then i cranked up the load to 50 infinite loops (!).
> No problems whatsoever. No problems at 100 tasks either. No problems
> with 250 (!) nice-0 infinite loops running either:

Different soundcards support different ranges and defaults for buffer
and period sizes and many naive apps don't bother to set a sane buffer
size.  Check the PCM states under /proc/asound/ on both good and bad
configs.

Lee
