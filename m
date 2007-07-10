Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXGJU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXGJU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXGJU0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:26:38 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52117 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbXGJU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:26:37 -0400
Date: Tue, 10 Jul 2007 21:25:50 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Bob Tracy <rct@gherkin.frus.com>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: 2.6.22-rc6 bad page error
In-Reply-To: <20070709185324.387ACDBA1@gherkin.frus.com>
Message-ID: <Pine.LNX.4.64.0707102120550.7594@blonde.wat.veritas.com>
References: <20070709185324.387ACDBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABWluYm94AGxpbnV4LWFscGhhQHZnZXIua2VybmVsLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGlua0BqdXJhc3NpYy5wYXJrLm1zdS5ydQBtaWNoYWwuay5rLnBpb3Ryb3dza2lAZ21haWwuY29tAHJjdEBnaGVya2luLmZydXMuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Bob Tracy wrote:
> > 
> > --- 2.6.22-rc7/arch/alpha/kernel/pci_iommu.c	2007-06-05 06:19:19.000000000 +0100
> > +++ linux/arch/alpha/kernel/pci_iommu.c	2007-07-07 15:00:04.000000000 +0100
> 
> That seems to have done the trick.  Normally, I get the "bad page"
> errors on the second NX session, but I'm on the third session of the
> day (thus far), and everything seems to be ok as far as I can tell.

Thanks a lot for the feedback, that tells us we've made the right
guesses, and my __GFP_COMP patch should be a good bandaid for you;
but for the right patch, let's wait to hear from Ivan.

Hugh
