Return-Path: <linux-kernel-owner+w=401wt.eu-S933819AbYGCHJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819AbYGCHJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYGCG6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43559 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYGCEll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:41:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>
	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>
Date: Wed, 02 Jul 2008 21:34:17 -0700
In-Reply-To: <486C062C.3090408@sgi.com> (Mike Travis's message of "Wed, 02 Jul
	2008 15:50:20 -0700")
Message-ID: <m1wsk3r3g6.fsf@frodo.ebiederm.org>
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
	*      [score: 0.0000]
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

> will only boot and run with gcc-4.2.0, and does the "failure at grub" screen
> with
> gcc-4.2.4 ...!

Do these tests have an early serial console enabled?  I want to confirm
that the failure is very early in boot before or just as we reach C code.

If you don't have an early console we could be failing late in the process just
not have visibility.

> Any other suggestions?

If you have a serial console to add a little bit of instrumentation super duper early.
Although looking at the generated objects might be just as interesting.

Eric

