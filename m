Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZE1W6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZE1W6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZE1W6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:58:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54349 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbZE1W6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:58:38 -0400
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org>
	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>
	<20090528001418.GA2499@kroah.com>
	<ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
	<20090528003721.GB2720@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 28 May 2009 15:58:25 -0700
In-Reply-To: <20090528003721.GB2720@suse.de> (Greg KH's message of "Wed\, 27 May 2009 17\:37\:21 -0700")
Message-ID: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, ebiederm@aristanetworks.com, dlezcano@fr.ibm.com, benjamin.thery@bull.net, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, greg@kroah.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3852]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 0/24] sysfs cleanups.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

>> > Or are there still problems, like the "fry the ext3 boot partition" that
>> > Kay found?
>> 
>> That is unrelated to Eric's patches, They just added the dump, which I
>> tried to trigger. It's not entirely clear what caused the filesytem
>> damage, but I was definitely able to reproduce the unclean shutdown
>> without any of Eric's sysfs patches.
>
> Ok.
>
> But I think Eric had some updates to some of the patches along the way,
> so a whole new respin would be good to ensure I get the correct ones.


Ok.  Here is my respun patchset.  I have not changed which files
we remove in a directory when we remove a non-empty directory.
Leaving that issue to be addressed another time.

To accommodate that I have respun two patches:

patch  4 sysfs: Normalize removing sysfs directories.
patch 15 sysfs: Kill sysfs_addrm_start and sysfs_addrm_finish

Killing addrm is only changed to track the previous differences.

Eric




