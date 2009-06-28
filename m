Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZF1Tvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZF1Tvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZF1Tvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:51:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47317 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZF1Tvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:51:45 -0400
To: tridge@samba.org
Cc: john.lanza@linux.com, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org>
	<m1d48p5dil.fsf@fess.ebiederm.org>
	<19014.54044.484370.187018@samba.org>
	<m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org>
	<87ab3sx4ch.fsf@devron.myhome.or.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 12:51:41 -0700
In-Reply-To: <87ab3sx4ch.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of "Sun\, 28 Jun 2009 15\:25\:02 +0900")
Message-ID: <m1k52wxhki.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tridge@samba.org, paulmck@linux.vnet.ibm.com, cmm@us.ibm.com, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org, hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org, john.lanza@linux.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;tridge@samba.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> tridge@samba.org writes:
>
>>  > Given what you have said our interpretation of vfat has a bug,
>>  > and that small change is a candidate for -stable.  If it could
>>  > be it's own patch.
>>
>> good point. 
>>
>> Hirofumi-san, would you support putting the last_u change into stable?
>
> If you want, I have no problem to do. However, I'm not thinking that
> part is a bug.  And -stable rule is also "a real bug that bothers
> people", but there is even a no bug reporter which tell actual problem.


Tridge.  Is there any reason to believe that Microsoft will continue
to treat Longfilenames without short filenames as valid in vfat?

If this turns into a contest of who can do the silliest things in
their vfat code microsoft could easily introduce a stricter directory
parser and cause all kinds of grief.

It wouldn't even surprise me if you haven't seen such shenanigans
while working on samba.

Eric
