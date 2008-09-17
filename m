Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYIQXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYIQXFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYIQXFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 19:05:19 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34369 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYIQXFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 19:05:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Moore <paul.moore@hp.com>, sds@tycho.nsa.gov, jmorris@namei.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, ebiederm@xmission.com,
       netdev@vger.kernel.org
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<200809171724.36269.paul.moore@hp.com>
	<20080917144842.7df59f9e.akpm@linux-foundation.org>
	<200809171812.59693.paul.moore@hp.com>
	<20080917152407.76230f0c.akpm@linux-foundation.org>
Date: Wed, 17 Sep 2008 15:53:42 -0700
In-Reply-To: <20080917152407.76230f0c.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 17 Sep 2008 15:24:07 -0700")
Message-ID: <m1wshawfih.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11500] /proc/net bug related to selinux
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 17 Sep 2008 18:12:59 -0400
> Paul Moore <paul.moore@hp.com> wrote:
>
>> > We don't even know the extent of the damage yet.  Which distros were
>> > affected? With which versions of which userspace packages?
>> 
>> Can I assume that the "right" thing to do would be to find the problem 
>> and revert whatever change caused the issue, yes?  Or are we happy to 
>> wait and see since the fallout so far has been minimal?
>
> I don't think a revert is justified after all this time.  afaik I'm the
> first person to notice the problem, and it's been out there for
> multiple months.
>
> However it would be good if we could find some not-completely-stinky
> way of making the old userspace work.
>
> otoh, people who are shipping 2.6.25- and 2.6.26-based distros probably
> wouldn't want such a patch in their kernels anyway.

Disable selinux?

Get a selinux mystic to update that selinux policy.  I bet it is a one line
change to each the policy about /proc/net as a symlink.

Although I am puzzled why we don't get the same label as /proc/net as a directory
had.

Eric

