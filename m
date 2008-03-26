Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbYCZHHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbYCZHHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYCZHHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:07:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58215 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYCZHHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:07:11 -0400
Date: Wed, 26 Mar 2008 08:06:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: Re: [PATCH 0/20] dma_ops for i386
Message-ID: <20080326070616.GI18301@elte.hu>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber Costa <gcosta@redhat.com> wrote:

> Hello,
> 
> Here there is a series of 20 patches that lays the foundations for 
> using dma_ops in i386 in the very same way x86_64, as well as many 
> other architectures already do.
> 
> The functions themselves for i386 are placed in a pci-base_32.c, but 
> just a few among them are actually implemented. Most were no-ops 
> anyway.
> 
> Also, as I said, this is by no means a complete coverage of dma_ops. 
> there are still some call sites to be patches in pci-dma_32.c 
> (although I don't really plan to change them, but to integrate them in 
> a single pci-dma.c). I intend to have it done progressively.
> 
> The granularity is per-operation, meaning each patch moves one 
> specific function to the common header. This is compiled-tested in 
> both i386 and x86_64 in ~5 randconfigs each, and boot-tested in my 
> hardware with my default configs
> 
> The motivation for that is the ongoing work for pci-passthrough in 
> KVM. So ingo, avi, what do you think it's the best way to handle these 
> patches through?

looks very nice to me! I've applied it to x86.git, lets see what 
happens.

	Ingo
