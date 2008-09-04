Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYIDVOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYIDVOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYIDVOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:14:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40699 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYIDVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:14:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com, ink@jurassic.park.msu.ru,
       jbarnes@virtuousgeek.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, dwmw2@infradead.org, sam@ravnborg.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
	<20080904012544.cabed847.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040143350.3452@nehalem.linux-foundation.org>
	<20080904015701.5959623a.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040203510.3452@nehalem.linux-foundation.org>
	<20080904104554.32ffebea.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809041058140.3400@nehalem.linux-foundation.org>
	<20080904113408.d47c65f6.akpm@linux-foundation.org>
	<m163pb4pru.fsf@frodo.ebiederm.org>
	<20080904134148.0fde4508.akpm@linux-foundation.org>
Date: Thu, 04 Sep 2008 14:03:41 -0700
In-Reply-To: <20080904134148.0fde4508.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 4 Sep 2008 13:41:48 -0700")
Message-ID: <m1zlmn39oy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: linux-next: Tree for September 3
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 04 Sep 2008 13:31:01 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> >> are you sure it's a plain tree of mine, without any of the patches 
>> >> floating around between Eric/Al?
>> >
>> > yup, it's yesterday's mainline.
>> 
>> Does the problem happen if you disable selinux?
>> 
>> This feels like a case of selinux being over zealous.
>
> yeah, adding `selinux=0' to the boot command line fixes it.

The proc generic directory back structure is the same.  As requested by
the selinux folks.  So I don't expect there is much more we can do on
the /proc side.

When we get the interaction bug between the VFS and /proc/net fixed I wonder
if there will be some more selinux fall out.  Something to think about.

Eric
