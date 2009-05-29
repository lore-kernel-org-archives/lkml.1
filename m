Return-Path: <linux-kernel-owner+w=401wt.eu-S1762738AbZE2RSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738AbZE2RSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762277AbZE2RR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:17:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51665 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762031AbZE2RR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:17:27 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	<1243551665-23596-22-git-send-email-ebiederm@xmission.com>
	<4A1FA7F4.9000708@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 29 May 2009 10:17:23 -0700
In-Reply-To: <4A1FA7F4.9000708@kernel.org> (Tejun Heo's message of "Fri\, 29 May 2009 18\:16\:36 +0900")
Message-ID: <m1iqjjbzh8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tj@kernel.org, ebiederm@aristanetworks.com, greg@kroah.com, kay.sievers@vrfy.org, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 22/24] sysfs: Make sysfs_rename_link atomic
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Use the existing sysfs_rename to make sysfs_rename_link an atomic
>> operation that does less work.  While I am at add additional sanity
>> checking to ensure it is a symlink I am renaming.
>> 
>> Acked-by: Kay Sievers <kay.sievers@vrfy.org>
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> It would be really nice to merge or group this together with the first
> three patches.  Other than that,

Perfection is the enemy of the good on that one.  That just convolutes
things unnecessarily, makes the patches harder to review, and requires
additional testing.

I much prefer to work in a tree without rewinding.

> Acked-by: Tejun Heo <tj@kernel.org>
>
> -- 
> tejun
