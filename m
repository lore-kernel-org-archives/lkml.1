Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbYGAIWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbYGAIWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYGAIVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:21:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53591 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYGAIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:21:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andy Whitcroft <apw@shadowen.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@in.ibm.com>
References: <20080701001656.e156585c.sfr@canb.auug.org.au>
	<48690385.7030500@linux.vnet.ibm.com>
	<48690D3C.1060803@linux.vnet.ibm.com>
	<20080630185943.GA24692@uranus.ravnborg.org>
	<20080630192610.GA6584@elte.hu>
	<20080630194727.GA26682@uranus.ravnborg.org>
	<20080630200623.GE6584@elte.hu>
	<20080630202506.GA28050@uranus.ravnborg.org>
	<486943F1.80606@zytor.com> <48695449.5010602@zytor.com>
Date: Tue, 01 Jul 2008 01:15:15 -0700
In-Reply-To: <48695449.5010602@zytor.com> (H. Peter Anvin's message of "Mon,
	30 Jun 2008 14:46:49 -0700")
Message-ID: <m17ic6qauk.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0029]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Here is a patch to replace the hard-coded limit with dynamic allocation. I have
> only build-tested it, but it seems to work.
>
> Please try it out; barring any screams to the contrary I'll add it to -tip.

Looks reasonable to me.  When generalizing from a test program to something
that can be used every day I think I just overlooked the fact that I had not
dynamically allocated the section count.

Eric
