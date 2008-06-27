Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbYF0ITL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbYF0ITL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYF0ISz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:18:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50519 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbYF0ISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:18:53 -0400
Date: Fri, 27 Jun 2008 10:18:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 00/34] AMD IOMMU driver
Message-ID: <20080627081807.GA6562@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this is the first post of the initial driver for AMD IOMMU hardware. 
> The driver is tested on hardware with various loads (disk and network) 
> and showed no problems.
> 
> It currently supports DMA remapping using the dma_ops API in the x86 
> architecture code. It also supports isolation of device DMA address 
> spaces as far as the hardware allows that (means each device can get 
> its own DMA address space and can't access the DMA memory of other 
> devices).

the code looks very clean. I guess down the line we might want to think 
about making all the externally visible knobs transparent: there should 
be only one way to disable the iommu via the boot command line (be that 
an AMD or Intel one), etc.

i have created a new -tip topic for this: tip/x86/amd-iommu and have 
applied your patches there - thanks Joerg. You can pick up the 
integrated tree via:

  http://people.redhat.com/mingo/tip.git/README

please check whether the integrated end result still works fine.
[ Obviously nobody but you can test this on real hw ;-) ]

	Ingo
