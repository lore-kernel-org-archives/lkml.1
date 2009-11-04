Return-Path: <linux-kernel-owner+w=401wt.eu-S932890AbZKDWXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbZKDWXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 17:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932827AbZKDWXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 17:23:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36443 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791AbZKDWXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 17:23:52 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-13-git-send-email-ebiederm@xmission.com>
	<20091104221957.GB21033@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 14:23:50 -0800
In-Reply-To: <20091104221957.GB21033@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 4 Nov 2009 16\:19\:57 -0600")
Message-ID: <m1my32vsi1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 13/13] sysfs: Factor out sysfs_rename from sysfs_rename_dir and sysfs_move_dir
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> These two functions do 90% of the same work and it doesn't significantly
>> obfuscate the function to allow both the parent dir and the name to change
>> at the same time.  So merge them together to simplify maintenance, and
>> increase testing.
>> 
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Based on just this patchset it seems sysfs_rename() could be static,
> but since it isn't static I assume your later patchset will use it
> outside fs/sysfs/dir.c?

To implement sysfs_rename_link, but that is too much to digest/review/push
all at once.

I have a snapshot of my development tree up on kernel.org if you are
interested.

Eric
