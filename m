Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYIERMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYIERMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYIERMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:12:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYIERMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:12:19 -0400
Date: Fri, 5 Sep 2008 19:12:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: x86: add northbridge detection for AMD family 0x11 cpus
Message-ID: <20080905171203.GA27395@elte.hu>
References: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
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
> this small patch series adds PCI device ids for the northbridge in AMD family
> 0x11 processors and adds the ids to the detection code. With this patches the
> GART in these processors is found by the kernel.
> 
> Regards,
> 
> Joerg
> 
> git diff --stat tip/master.. :
> 
>  arch/x86/kernel/k8.c    |    5 +++--
>  include/linux/pci_ids.h |    5 +++++
>  2 files changed, 8 insertions(+), 2 deletions(-)

applied to tip/x86/iommu, thanks Joerg.

	Ingo
