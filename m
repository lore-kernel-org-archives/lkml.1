Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZGIUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZGIUdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZGIUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:33:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53351 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZGIUdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:33:03 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dominic Duval <dduval@redhat.com>, Frank Hirtz <fhirtz@redhat.com>,
       "Fuller\, Johnray" <Johnray.Fuller@gs.com>,
       "James M. Leddy" <jleddy@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Paul Batkowski <pbatkowski@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
References: <20090709173610.GA29069@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 09 Jul 2009 13:32:58 -0700
In-Reply-To: <20090709173610.GA29069@redhat.com> (Oleg Nesterov's message of "Thu\, 9 Jul 2009 19\:36\:10 +0200")
Message-ID: <m1ws6hr405.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, roland@redhat.com, pbatkowski@redhat.com, lwoodman@redhat.com, jleddy@redhat.com, Johnray.Fuller@gs.com, fhirtz@redhat.com, dduval@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/1] proc_flush_task: flush /proc/tid/task/pid when a sub-thread exits
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Alexey, Eric, could you please review and ack/nack ?
>
> I just can't understand what was the reason for "if (thread_group_leader())"
> check in proc_flush_task() pathes.

Give me a day or two.

There are definitely bugs there.  My cleanup patch for that has gotten
lost several times.

All of this is an optimization so it isn't critical we get this right.
Just a good idea.

Eric
