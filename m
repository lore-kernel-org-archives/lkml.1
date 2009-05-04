Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZEDUVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZEDUVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEDUU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:20:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53946 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZEDUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:20:56 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <20090504125114.5e391564@chukar>
	<alpine.LFD.2.01.0905041159480.4983@localhost.localdomain>
	<20090504125124.0f469970@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 04 May 2009 13:20:51 -0700
In-Reply-To: <20090504125124.0f469970@infradead.org> (Arjan van de Ven's message of "Mon\, 4 May 2009 12\:51\:24 -0700")
Message-ID: <m1vdogbows.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: arjan@infradead.org, greg@kroah.com, akpm@linux-foundation.org, mingo@redhat.com, roland@redhat.com, alan@lxorguk.ukuu.org.uk, eparis@redhat.com, linux-security-module@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, security@kernel.org, jake@lwn.net, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arjan van de Ven <arjan@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Mon, 4 May 2009 12:00:12 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> 
>> 
>> On Mon, 4 May 2009, Jake Edge wrote:
>> >
>> > This is essentially v2 of "[PATCH] proc: avoid leaking eip, esp, or
>> > wchan to non-privileged processes", adding some of Eric Biederman's
>> > suggestions as well as the start_stack change (only give out that
>> > address if the process is ptrace()-able).  This has been tested
>> > with ps and top without any ill effects being seen.
>> 
>> Looks sane to me. Anybody objects?
>> 
>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Looks sane here.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
