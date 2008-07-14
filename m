Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYGNSmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYGNSmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYGNSmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:42:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42063 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYGNSmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:42:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Bernhard Walle" <bwalle@suse.de>, "Vivek Goyal" <vgoyal@redhat.com>,
       kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <1214510048-21215-1-git-send-email-bwalle@suse.de>
	<20080627133256.GB5801@redhat.com>
	<86802c440807140011v728cc35fy2540b537ddca9844@mail.gmail.com>
	<20080714112404.36783df5@halley.suse.de>
	<m1od50ztoa.fsf@frodo.ebiederm.org>
	<86802c440807141006o98afac8t66b0933d8acd2746@mail.gmail.com>
	<m17iboz83v.fsf@frodo.ebiederm.org>
	<86802c440807141117q218fdd61w1216dc6ded72252a@mail.gmail.com>
Date: Mon, 14 Jul 2008 11:41:36 -0700
In-Reply-To: <86802c440807141117q218fdd61w1216dc6ded72252a@mail.gmail.com>
	(Yinghai Lu's message of "Mon, 14 Jul 2008 11:17:16 -0700")
Message-ID: <m1r69wxq8v.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4302]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: Find offset for crashkernel reservation automatically
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On Mon, Jul 14, 2008 at 10:30 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>>
>>> for 64bit, kdump can start from address above 4g with bzImage?
>>
>> I think the boot protocol was properly updated for that, it was in the
>> original drafts.  A relocatable kernel with a 64bit entry point.
>>
>> I do know that the 64bit code is ready to do that.
>
> but bzImage for 64bit still use 32bit entries, except kexec could
> uncompress the bzImage like xen domain builder.

>From the standpoint of the crashdump option it doesn't matter.
As the vmlinux supports it, and bzImage could easily support it,
the decompresser is 64bit code.

If bzImage doesn't support it that is a bug we will have to
correct one of these years when it actually matters.

Eric
