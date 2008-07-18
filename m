Return-Path: <linux-kernel-owner+w=401wt.eu-S932090AbYGRUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbYGRUMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYGRUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:12:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34070 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760180AbYGRUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:12:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
References: <20080718150410.GB26261@hack.voiplan.pt>
Date: Fri, 18 Jul 2008 13:07:58 -0700
In-Reply-To: <20080718150410.GB26261@hack.voiplan.pt> (WANG Cong's message of
	"Fri, 18 Jul 2008 16:04:10 +0100")
Message-ID: <m1sku7j6qp.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;WANG Cong <xiyou.wangcong@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] kexec: remove redundant if-else
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong <xiyou.wangcong@gmail.com> writes:

> These if-else's can be removed.

Why?  That appears to be pointless code style thrashing.

Converting code with a single return into code with multiple returns.
Which arguably makes it harder to prove properties about.

Further if you want to use the style you suggest a label name like err
is better than the name out.

But in this case where we have multiple results I don't like the proposed
change in style at all.  Especially with no rational.

Eric
