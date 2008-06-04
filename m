Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYFDBvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYFDBvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYFDBve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:51:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35742 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbYFDBvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:51:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       dhazelton@enter.net, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
References: <20080603190235.GA9511@c2.user-mode-linux.org>
	<20080603123211.e129c222.akpm@linux-foundation.org>
	<200806031543.56864.dhazelton@enter.net>
	<878wxmfg99.fsf@hades.wkstn.nix>
	<20080603130709.fcf6a751.akpm@linux-foundation.org>
	<20080603210048.GA12182@c2.user-mode-linux.org>
Date: Tue, 03 Jun 2008 18:50:49 -0700
In-Reply-To: <20080603210048.GA12182@c2.user-mode-linux.org> (Jeff Dike's
	message of "Tue, 3 Jun 2008 17:00:48 -0400")
Message-ID: <m1zlq2vuh2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeff Dike <jdike@addtoit.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0023]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMPlayFrnd1 XMPlayFrnd: Play Friend Spam 1 Or More Qualities
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike <jdike@addtoit.com> writes:

> On Tue, Jun 03, 2008 at 01:07:09PM -0700, Andrew Morton wrote:
>> So if I change the host's time by an hour, the time will not advance at all
>> on the guest for the next hour? Sounds suboptimal :)
>
> It is, but if the host is whacked, the guest just has to do the best that
> it can...

Could using a CLOCK_MONOTONIC time source fix this?  Those timers do not
change when we change the time on the host.

Eric
