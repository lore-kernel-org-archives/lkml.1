Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYKFUaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYKFUaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:30:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYKFU3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:29:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYKFU3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:29:50 -0500
Date: Thu, 6 Nov 2008 21:29:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU fixes for 2.6.28
Message-ID: <20081106202907.GC3578@elte.hu>
References: <20081106141555.GD22503@amd.com> <49133D15.4020607@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49133D15.4020607@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Joerg Roedel wrote:
>> Hi Ingo,
>>
>> The following changes since commit 1e19b16a30c34c042f1eaa23db4c99bfad1dac0e:
>>   Thomas Gleixner (1):
>>         AMD IOMMU: use iommu_device_max_index, fix
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28
>>
>> Joerg Roedel (2):
>>       AMD IOMMU: fix detection of NP capable IOMMUs
>>       AMD IOMMU: fix lazy IO/TLB flushing in unmap path
>>
>>  arch/x86/kernel/amd_iommu.c |    9 +++++++--
>>  1 files changed, 7 insertions(+), 2 deletions(-)
>>
>> This are 2 important bugfixes which fix lazy IO/TLB flushing with the
>> driver. Please pull.
>
> Even though the x86 maintainers probably don't require it, it would 
> be nice if you could include the changes being pushed in the same 
> email (provided the patch is under 400k).  Every little bit of 
> additional review helps.

agreed, that would be nice to have for future pull requests.

	Ingo
