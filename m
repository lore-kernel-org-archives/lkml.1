Return-Path: <linux-kernel-owner+w=401wt.eu-S1759801AbYGQSxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801AbYGQSxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759671AbYGQSwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:52:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57343 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759231AbYGQSwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:52:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: sukadev@us.ibm.com
Cc: Daniel Hokka Zakrisson <daniel@hozac.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, xemul@openvz.org,
       oleg@tv-sign.ru, akpm@linux-foundation.org, ebiederm@xmission.com
References: <487F5D6B.1090007@hozac.com> <20080717181313.GA2289@us.ibm.com>
Date: Thu, 17 Jul 2008 11:46:23 -0700
In-Reply-To: <20080717181313.GA2289@us.ibm.com> (sukadev@us.ibm.com's message
	of "Thu, 17 Jul 2008 11:13:13 -0700")
Message-ID: <m1mykgtklc.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;sukadev@us.ibm.com
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2780]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/2] signals: kill(-1) should only signal processes in the same namespace
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com writes:
>

> Like Pavel said, we had couple of attempts to fix the larger problem of
> signal semantics in containers but did not have a consensus on handling
> blocked/unhandled signals to container-init.

Oh.  I thought we were pretty close then I or somebody ran out of steam.

> It would still be good to fix this "kill -1" problem.
>
> Eric had a slightly optimized interface, 'pid_in_pid_ns()' in following
> patchset. Maybe we could use that ?
>
> https://lists.linux-foundation.org/pipermail/containers/2007-December/009174.html

Eric

