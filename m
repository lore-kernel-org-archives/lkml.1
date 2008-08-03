Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYHCGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYHCGnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 02:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYHCGnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 02:43:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36011 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYHCGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 02:43:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1217642575-22727-1-git-send-email-yhlu.kernel@gmail.com>
	<m18wveacu6.fsf@frodo.ebiederm.org>
	<86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com>
Date: Sat, 02 Aug 2008 23:35:42 -0700
In-Reply-To: <86802c440808022258x1198093x7d21274b82e75f4b@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 2 Aug 2008 22:58:24 -0700")
Message-ID: <m1sktm7ght.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Yinghai Lu" <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4040]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_64: Restore the proper NR_IRQS define so larger systems work.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:


> what should xen pv 64 get for NR_IRQS?

Xen pv 64 will work at least as well with a larger definition for
NR_IRQS as it will work with a smaller definition, and since
NR_VECTORS is 256 we always have more irqs with the 32bit definition
we were mistakenly using. 

Xen has 1024 event channels so I expect 1024 would the nice number to
provide there.

Eric

