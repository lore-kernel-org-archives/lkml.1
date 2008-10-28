Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYJ1SPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYJ1SPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYJ1SPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:15:05 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:1193 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYJ1SPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bEeYATVto1GCljjd8MsZgQJYaIG+CZLC9cVJn39bFgAbu5bLaxk1uHKiDuNDRpxY7E
         MJgH7tp7w3sK5a0CiAUl0PQFkxL4ogfrB1amVaaB/IpVqRWo4se39ABK8ACrACNnqrqc
         7W+Uu5hXAZ52y7cTNo2j4KorblOvLbmHwT7YI=
Message-ID: <c62985530810281115n5e40539ek1a486a0b909e339c@mail.gmail.com>
Date: Tue, 28 Oct 2008 19:15:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>
	 <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>
	 <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>
	 <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
	 <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>
	 <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>
	 <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/28 Steven Rostedt <rostedt@goodmis.org>:
>
> On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:
>>
>> An that corrects the bug when I failed to assign the sched_switch tracer.
>> Thanks Steven!
>>
>> Tested-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> Do you still have issues with the function tracer in the latest linux-tip?
> If so, can you rebuild it from scratch, send me the config again, and
> explain in detail what the issue is.
>
> Thanks,

I think I've caught it. See the patch I just Cc'ed you:
ftrace: perform an initialization for ftrace to enable it

Thanks!
