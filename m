Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZEUKaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZEUKaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZEUKaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:30:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48556 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZEUKaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:30:00 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-5-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-6-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-7-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-8-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-9-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-10-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-11-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-12-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-13-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-14-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-15-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-16-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-17-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-18-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-19-git-send-email-ebiederm@xmission.com>
	<1242865694-2100-20-git-send-email-ebiederm@xmission.com>
	<4A152255.9060703@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 03:29:57 -0700
In-Reply-To: <4A152255.9060703@kernel.org> (Tejun Heo's message of "Thu\, 21 May 2009 18\:43\:49 +0900")
Message-ID: <m1r5yiu4t6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0022]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 20/20] sysfs: Normalize error handling in sysfs_fill_inode
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Use a single error exit path instead of doing whatever
>> is the required cleanup at each point we find the error.
>> Ultimately this should make the code more maintainable.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> For 0018-0020,
>
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks for taking the time to review these patches.

Eric
