Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYGGTwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYGGTwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbYGGTvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:51:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58208 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYGGTvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:51:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>
	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>
Date: Mon, 07 Jul 2008 12:46:00 -0700
In-Reply-To: <48724FB4.3090305@sgi.com> (Mike Travis's message of "Mon, 07 Jul
	2008 10:17:40 -0700")
Message-ID: <m17ibxxytj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:
> Hi,
>
> Sorry for the delay, been off the past 4 days.
>
> I'll see how closely I can narrow down where the fault is.  I have been
> inserting
> very early printk's to track how far into the startup it gets before bailing.

Thanks.  That should help narrow down what is going on.

Eric
