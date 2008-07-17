Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbYGQSC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbYGQSC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYGQSCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:02:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58449 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYGQSCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:02:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Hokka Zakrisson <daniel@hozac.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       oleg@tv-sign.ru, xemul@openvz.org, akpm@linux-foundation.org
References: <487F5DA1.6000107@hozac.com>
Date: Thu, 17 Jul 2008 10:55:15 -0700
In-Reply-To: <487F5DA1.6000107@hozac.com> (Daniel Hokka Zakrisson's message of
	"Thu, 17 Jul 2008 10:56:33 -0400")
Message-ID: <m14p6ov1j0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Hokka Zakrisson <daniel@hozac.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3870]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/2] signals: replace p->pid == 1 check with a check for task_child_reaper
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hokka Zakrisson <daniel@hozac.com> writes:

> p->pid == 1 is insufficient when there are multiple pid namespaces.
> Instead, check whether the task is in the current task's
> child reaper's thread group.

We should just drop the check for init as it is redundant.

Eric

