Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZGDJNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZGDJNk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 05:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZGDJNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 05:13:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49892 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZGDJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 05:13:31 -0400
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	<6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>
	<4A4C18D5.7020806@cn.fujitsu.com>
	<6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
	<4A4C1B33.2030002@cn.fujitsu.com> <20090702132659.GA8051@us.ibm.com>
	<6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 04 Jul 2009 02:13:29 -0700
In-Reply-To: <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com> (Paul Menage's message of "Thu\, 2 Jul 2009 08\:43\:57 -0700")
Message-ID: <m1ocs0dd52.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: menage@google.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lizf@cn.fujitsu.com, serue@us.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Paul Menage <menage@google.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage <menage@google.com> writes:

> On Thu, Jul 2, 2009 at 6:26 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>> Quoting Li Zefan (lizf@cn.fujitsu.com):
>>> Paul Menage wrote:
>>> > On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>>> >> But I guess we are going to fix the bug for 2.6.31? So is it ok to
>>> >> merge a new feature 'cgroup.procs' together into 2.6.31?
>>> >>
>>> >
>>> > Does this bug really need to be fixed for 2.6.31? I didn't think that
>>> > the namespace support in mainline was robust enough yet for people to
>>> > use them for virtual servers in production environments.
>>
>> I don't know where the bar is for 'production environments', but I'd
>> have to claim that pid namespaces are there...
>
> Well, pid namespaces are marked as experimental, as are user
> namespaces (and were described as "very incomplete" a few months
> back). Pid namespaces are useful for process migration (which is still
> under development) or virtual servers (for which user namespaces are
> pretty much essential). So I'm not sure quite what you'd use pid
> namespaces for yet.

I have pid namespaces in pretty heavy use already.

Inescapable process groups are quite handy.

Eric

