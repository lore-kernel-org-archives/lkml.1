Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbYHAUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbYHAUD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbYHAUDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:03:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48588 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241AbYHAUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:03:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731170022.GE9663@sgi.com>
	<m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com>
	<m1iqul25rk.fsf@frodo.ebiederm.org> <20080731200835.GK9663@sgi.com>
	<m1bq0d1zhz.fsf@frodo.ebiederm.org> <20080801120455.GP9663@sgi.com>
	<m1proszj3r.fsf@frodo.ebiederm.org> <20080801191336.GK10501@sgi.com>
Date: Fri, 01 Aug 2008 12:59:52 -0700
In-Reply-To: <20080801191336.GK10501@sgi.com> (Robin Holt's message of "Fri, 1
	Aug 2008 14:13:36 -0500")
Message-ID: <m14p64zetj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robin Holt <holt@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2289]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> Oops, confusing details.  That was a different problem we had been
> tracking.

Which leads back to the original question.  What were you measuring
that showed improvement with a larger pid hash size?

Almost by definition a larger hash table will perform better.  However
my intuition is that we are talking about something that should be in
the noise for most workloads.

Eric
