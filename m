Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYKZHGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYKZHGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYKZHGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:06:08 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35642 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:06:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, containers@lists.osdl.org,
       fweisbec@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       srostedt@redhat.com, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20081125223456.976670734@goodmis.org>
	<20081125144221.66eb99ad.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251800130.26424@gandalf.stny.rr.com>
	<20081125153104.ecdceed4.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811251909320.26424@gandalf.stny.rr.com>
	<1227660839.12109.52.camel@nimitz>
	<alpine.DEB.1.10.0811251956570.26424@gandalf.stny.rr.com>
	<m1zljndrb6.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0811260000400.26424@gandalf.stny.rr.com>
	<m1abbnc8ff.fsf@frodo.ebiederm.org> <20081126063201.GF9732@elte.hu>
Date: Tue, 25 Nov 2008 23:02:10 -0800
In-Reply-To: <20081126063201.GF9732@elte.hu> (Ingo Molnar's message of "Wed,
	26 Nov 2008 07:32:01 +0100")
Message-ID: <m1zljn7yx9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 1/3] ftrace: add function tracing to single thread
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> i dont see the point of the complexity you are advocating. 99.9% of 
> the users run a unique PID space.

I'm not advocating complexity.  I'm advocating using the same APIs as
the rest of the kernel, for doing the same functions.

> Tracing is about keeping stuff simple. On containers we could also 
> trace the namespace ID (is there an easy ID for the namespace, as an 
> easy extension to the very nice PID concept that Unix introduced 
> decades ago?) and be done with it.

I don't really care about the pid namespace in this context.

I am just asking that we compare a different field in the task struct.

I am asking that we don't accumulate new users of an old crufty bug prone
API, for no good reason.

I'm asking that we don't be different for no good reason.

Eric
