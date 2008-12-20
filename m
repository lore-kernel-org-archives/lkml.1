Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYLTNIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYLTNIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 08:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYLTNIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 08:08:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:40068 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYLTNIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 08:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gRycVnITJubl6DpESkORhqI57ikHZS4KANIG/m0J1B2EWqB3lnKopBzZnaIn3ccxs+
         7Kf1hq3Ciq3qrkk0tp6adbxlKQR/qQy9pgpy4n1QgJxU90IkPmK9ifFpAl4wKeshJuUI
         qKyhEDCw8OxeHLdk3VH63fEhEEhZ+5qz2iewI=
Message-ID: <c62985530812200508y660c3506mbcc0f317409e1812@mail.gmail.com>
Date: Sat, 20 Dec 2008 14:08:40 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 1/7] ftrace: fix task state printout
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Clark Williams" <clark.williams@gmail.com>,
       "Gregory Haskins" <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0812192239280.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081219155504.735865178@linutronix.de>
	 <20081219155555.919550408@linutronix.de>
	 <c62985530812190825k4e4f5a7apa37e1ab4bc35753a@mail.gmail.com>
	 <alpine.LFD.2.00.0812192239280.3376@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/19 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 19 Dec 2008, Frédéric Weisbecker wrote:
>> Hi Thomas,
>>
>> 2008/12/19 Thomas Gleixner <tglx@linutronix.de>:
>> > Impact: tracer task state decoding is wrong, size check is buggy
>> >
>> > The tracing code has interesting varieties of printing out task state.
>> > Unfortunalely only one of the instances is correct as it copies the
>> > code from sched.c:sched_show_task(). The others are plain wrong as
>> > they treatthe bitfield as an integer offset into the character
>> > array. Also the size check of the character array is wrong as it
>> > includes the trailing \0.
>> >
>> > Use a common state decoder inline which does the Right Thing.
>> >
>> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>>
>> You've already sent it out. It has been applied on -tip :-)
>
> Yep, but these patches are against 2.6.24.7-rt24 as noted in the
> subject line of patch 0/7 :)
>
> Thanks,
>
>        tglx
>

Oh ok sorry....
