Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYG2XXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYG2XXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYG2XWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:22:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47740 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYG2XWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:22:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Mike Travis" <travis@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, "Jack Steiner" <steiner@sgi.com>,
       "Alan Mayer" <ajm@sgi.com>, "Cliff Wickman" <cpw@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
	<86802c440807291521k6e6277b5ta05b180d0d1c963a@mail.gmail.com>
Date: Tue, 29 Jul 2008 16:12:50 -0700
In-Reply-To: <86802c440807291521k6e6277b5ta05b180d0d1c963a@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 29 Jul 2008 15:21:02 -0700")
Message-ID: <m17ib48etp.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0149]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>> But this would be a show stopper for SGI being able to ship systems if the
>> distros do not want to waste this much memory and won't set NR_CPUS=4096.
>
> wonder if nr_irqs need to be probed dynamically too.

NR_IRQS simply needs to die.

Eric
