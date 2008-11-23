Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYKWNEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYKWNEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbYKWNEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:04:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbYKWNEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:04:34 -0500
Date: Sun, 23 Nov 2008 14:04:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, netdev@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] x86: add initialization code for DMA-API
	debugging
Message-ID: <20081123130419.GA570@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-4-git-send-email-joerg.roedel@amd.com> <20081121174348.GB4336@elte.hu> <20081122094807.GK29705@8bytes.org> <20081123112818.GC29663@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123112818.GC29663@elte.hu>
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


Another generic suggestion:

Why not just replace dma_ops with a debug version? That way it could 
be a runtime feature based off the already existing DMA op callbacks, 
without any extra overhead.

I'd prefer such a solution much more with an x86 architecture 
maintainer hat on, because this way distributions could enable this 
debug feature (with the facility being off by default) without 
worrying about the wrapping overhead.

This would basically be a special variant of stacked DMA ops support.

	Ingo
