Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYIQWfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYIQWfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 18:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbYIQWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 18:35:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35480 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYIQWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 18:35:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Moore <paul.moore@hp.com>, sds@tycho.nsa.gov, jmorris@namei.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, netdev@vger.kernel.org
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	<20080917125053.1f9ecf37.akpm@linux-foundation.org>
	<200809171724.36269.paul.moore@hp.com>
	<20080917144842.7df59f9e.akpm@linux-foundation.org>
Date: Wed, 17 Sep 2008 15:32:49 -0700
In-Reply-To: <20080917144842.7df59f9e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 17 Sep 2008 14:48:42 -0700")
Message-ID: <m17i9axv1q.fsf@frodo.ebiederm.org>
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
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0144]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11500] /proc/net bug related to selinux
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> We don't even know the extent of the damage yet.  Which distros were
> affected? With which versions of which userspace packages?

This seems to me to be an extremely fragile selinux user space policy.
In their code that derives security labels from path names.
Why don't we have AppArmor in the kernel again?

Further I don't see how we could have possibly have supported that user space
policy.  How can we apply a user space defined label required by the selinux
policy to a symlink that did not exist?

I expect cd /proc/self/net would work.  In your situation and you can
see /proc/self/net/dev.

Everything here sounds to me like that selinux policy is impossibly brittle.
And anything that is that brittle I have no intention in claiming is a bug
in proc.

Eric
