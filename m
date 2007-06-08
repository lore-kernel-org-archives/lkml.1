Return-Path: <linux-kernel-owner+w=401wt.eu-S969113AbXFHQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969113AbXFHQIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969848AbXFHQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:07:55 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:12148 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969050AbXFHQHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:07:53 -0400
Message-ID: <46697ED4.3050403@de.ibm.com>
Date: Fri, 08 Jun 2007 18:07:48 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       jbaron@redhat.com, rostedt@goodmis.org, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu> <46674EA9.9090601@de.ibm.com> <1181198376.7348.202.camel@twins> <4667ACC3.60009@de.ibm.com> <20070607072720.GA19976@elte.hu>
In-Reply-To: <20070607072720.GA19976@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> if the infrastructure your are advocating does not allow us to keep the 
> existing output then it's simply not flexible enough.

Let's be precise. If "keep the existing output" means any format change is
unacceptible to you, then I broke things. If it means that my method provides
data equivalent in respect of content, then I didn't break the lock contention
output.

> Why on earth are you even arguing about this?
 > A "cleanup" should not change the output, simple as that.
 > Do a patch that has the _same_ output and then we can
> see whether it's a good patch. You made the same mistake with your 
> /proc/timer_stats cleanups.

We got to be careful here. My other proposal was doomed because timerstat became 
kernel ABI in the meantime. We won't break the kernel ABI. I was late, as simple 
as that.

The lock contention stuff isn't kernel ABI yet. This is -mm code, stuff
intented for a wider audience and discussion. It should be perfectly fine
to scrutinize kernel ABI additions before we get beyond the point of no return.

> I dont like NACK-ing patches but you seem to 
> be missing the basic precondition of cleanups: no functional effect to 
> the code, and certainly no change in output.

I don't see the point of judging something by goals that have not been set.
I have advertised my patches as: same purpose, different or generalised method,
differences in output format, output equivalent in respect of content,
much more code sharing.

Martin

