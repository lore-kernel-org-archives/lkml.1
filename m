Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0BRBCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:02:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:32775 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab0BRBCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:02:00 -0500
To: Neil Brown <neilb@suse.de>
Cc: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <19314.1869.847327.15190@notabene.brown>
	<20100210230625.GB678@suse.de> <m1fx57zbyl.fsf@fess.ebiederm.org>
	<20100211223235.GC30430@suse.de> <m1bpfvz8wy.fsf@fess.ebiederm.org>
	<20100217223848.GA31557@kroah.com>
	<20100218113912.4a3d36e9@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Feb 2010 17:01:50 -0800
In-Reply-To: <20100218113912.4a3d36e9@notabene.brown> (Neil Brown's message of "Thu\, 18 Feb 2010 11\:39\:12 +1100")
Message-ID: <m18warpda9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Neil Brown <neilb@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] sysfs: differentiate  between locking links and non-links
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> On Wed, 17 Feb 2010 14:38:48 -0800
> Greg KH <greg@kroah.com> wrote:

>> Got it, I've fixed this by hand.
>> 
>>
>
> Thanks.
> I hadn't sent you a fix myself (As requested) as I got the impression from
> the following discussion that a different approach would be taken.
>
> I'm happy either way though.

I had the same impression.

For simplicity I didn't base my patches on Neils because I would just
have had to undo it when I modified directories and symlinks to not
mess with s_active.

Eric
