Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYKTRgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYKTRgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYKTRgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:36:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55246 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbYKTRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:35:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: "Serge Hallyn" <serue@us.ibm.com>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru
References: <cfd18e0f0811191204r4ccaeaf4m4145e67f408543e0@mail.gmail.com>
	<m1vdujdvi6.fsf@frodo.ebiederm.org>
	<cfd18e0f0811200349q788c2767i5164dc1c47e67925@mail.gmail.com>
Date: Thu, 20 Nov 2008 09:33:44 -0800
In-Reply-To: <cfd18e0f0811200349q788c2767i5164dc1c47e67925@mail.gmail.com>
	(Michael Kerrisk's message of "Thu, 20 Nov 2008 06:49:54 -0500")
Message-ID: <m1zlju9u9z.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0881]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Current state of CLONE_NEWUSER?
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk" <mtk.manpages@googlemail.com> writes:

> Hi Eric,
>
> On Wed, Nov 19, 2008 at 8:41 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
>>
>>> Hi Serge,
>>>
>>> What is the current status of CLONE_NEWUSER?  I'm currently trying to
>>> test this flag in preparation for documenting it in the clone(2) man
>>> page, but am running into an ENOMEM error from the clone() call, which
>>> seems to occur after a failure in kobject_init_and_add() in the
>>> following call sequence:
>>>
>>> clone_user_ns() --> alloc_uid() --> uids_user_create() -->
>>> kobject_init_and_add()
>>>
>>> Are there already some test programs somewhere?  Is there any
>>> documentation already available for this flag?
>>
>> This code is definitely still under development.
>>
>> When complete it should be able to create a new uid namespace,
>> as an unprivileged user.  Creating a new process with uid == gid == 0.
>> Have a full set of caps.  And have permission to do nothing on the system
>> except read world readable files and write world writable files.
>
> Thanks for the info,
>
> So the error I described is expected?

I don't think so.  Serge?

Eric
