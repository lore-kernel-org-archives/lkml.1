Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531AbYGKKcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbYGKKcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 06:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYGKKcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 06:32:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47632 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYGKKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 06:32:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
Date: Fri, 11 Jul 2008 03:22:01 -0700
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> (Joerg
	Roedel's message of "Thu, 26 Jun 2008 21:27:36 +0200")
Message-ID: <m1d4lk90vq.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Joerg Roedel <joerg.roedel@amd.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1695]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/34] AMD IOMMU driver
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> writes:

> Hi,
>
> this is the first post of the initial driver for AMD IOMMU hardware. The driver
> is tested on hardware with various loads (disk and network) and showed no
> problems.
>
> It currently supports DMA remapping using the dma_ops API in the x86
> architecture code. It also supports isolation of device DMA address spaces as
> far as the hardware allows that (means each device can get its own DMA address
> space and can't access the DMA memory of other devices).
>
> Please give this code a good review and send me your comments about it so that
> I can fix all possible bugs and objections and move this driver forward to
> merging quality.

Small question.  Does this IOMMU also support irq remapping?

Intel is starting to merge support for their iommu that supports irq
remapping and I am curious what the implications are going to be to
support both of these iommus?

Assuming their is irq remapping support it isn't tied to x2apic
support in the cpus is it?

Eric
