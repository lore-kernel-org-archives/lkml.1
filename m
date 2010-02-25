Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0BYBfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 20:35:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42551 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab0BYBfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 20:35:37 -0500
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Americo Wang <xiyou.wangcong@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
	<ClJsQB_ZlxO.A.YyG.4dagLB@chimera>
	<2375c9f91002211730l6835cae1x1693da3d94fccc0c@mail.gmail.com>
	<alpine.LSU.2.00.1002250051380.4394@sister.anvils>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 24 Feb 2010 17:35:26 -0800
In-Reply-To: <alpine.LSU.2.00.1002250051380.4394@sister.anvils> (Hugh Dickins's message of "Thu\, 25 Feb 2010 01\:03\:14 +0000 \(GMT\)")
Message-ID: <m1d3zu5c81.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Bug #15202] lockdep warning during elevator_switch
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh.dickins@tiscali.co.uk> writes:

> On Mon, 22 Feb 2010, Américo Wang wrote:
>> On Mon, Feb 22, 2010 at 5:30 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a summary report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.32.  Please verify if it still should be listed and let the tracking team
>> > know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15202
>> > Subject         : lockdep warning during elevator_switch
>> > Submitter       : Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> > Date            : 2010-01-31 23:55 (22 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=126498212613051&w=4
>> >
>> 
>> This should be fixed by:
>> http://lkml.org/lkml/2010/2/11/329
>
> This regression does still need to be listed for 2.6.33-rc8-git.
>
> Americo is right that the warning goes away if I apply those patches from Eric,
> but they look like more than we'd be adding into 2.6.33 at this stage ...
> and bootup of latest git plus those patches gave me 71 messages of the form
> BUG: key fxxxxxxx not in .data!

Which probably means one or two more spots that need annotation.

2.6.33 is out so these are targeted for 2.6.34...

Eric
