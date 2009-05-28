Return-Path: <linux-kernel-owner+w=401wt.eu-S1763097AbZE1BwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763097AbZE1BwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbZE1Bv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:51:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52690 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095AbZE1Bv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:51:56 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<20090528001418.GA2499@kroah.com>
	<ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 27 May 2009 18:51:47 -0700
In-Reply-To: <ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com> (Kay Sievers's message of "Thu\, 28 May 2009 02\:30\:15 +0200")
Message-ID: <m1my8y570s.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, ebiederm@aristanetworks.com, dlezcano@fr.ibm.com, benjamin.thery@bull.net, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0011]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Thu, May 28, 2009 at 02:14, Greg KH <greg@kroah.com> wrote:
>>
>> So, there's been a lot of talk in this thread.
>>
>> Eric, do you have an updated set of patches for me to try out?
>
> I think we should get a version of the patch in that removes all files
> in a directory on cleanup, but warn if a subdirectory is still there.
> James has a patch to fix the one issue we've seen so far with existing
> child directories.
>
> After that, we should work on fixing the users that leave files
> behind, and can possibly stop cleaning up files, if we want to.

Agreed.  We are not yet ready to only remove empty directories from sysfs.
So fixing that problem with the current sysfs should be done in a
separate patchset after the other fixes.

I will look at putting that together.

Eric
