Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYKLKdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYKLKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 05:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYKLKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 05:33:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:24684 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYKLKde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 05:33:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JFwuZSi+leMSsN4UBwDIgikD7bTBQ82ZnO1aLzetm04ZaEUzfKRR6Xd4fCh1PGyUH1
         +N+mdUdxJmcxlE/tXmxxKzFv5a4TlHL9Nnc/id6ZTrZ2PWez8Xhzx6r3YowcW95LAQE8
         LUxG5lQhhQdFa9I0lc8L+LDGobCUsuvtcXjzs=
Message-ID: <c62985530811120233t2db891a3ta0930b85593f55c5@mail.gmail.com>
Date: Wed, 12 Nov 2008 11:33:30 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/fastboot: Use the ring-buffer timestamp for initcall entries
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081112102103.GA24482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081112055454.798779203@goodmis.org>
	 <20081112055600.657041406@goodmis.org>
	 <20081111220051.204c43f2.akpm@linux-foundation.org>
	 <c62985530811120045j5fc0475r8c374f4853f6823e@mail.gmail.com>
	 <20081112102103.GA24482@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/11/12 Andrew Morton <akpm@linux-foundation.org>:
>> > On Wed, 12 Nov 2008 00:54:56 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> >> -     unsigned long long      duration;               /* usecs */
>> >> +     unsigned long long      duration;
>> >
>> > my hard-won comment got fragged.
>>
>>
>> Oops. I forgot it.
>> Perhaps I should resend a patch that reset this comment?
>> BTW it is nsecs actually.
>
> no need, i fixed it up when applying your patch to tracing/fastboot,
> and also changed it to nsecs.
>
>        Ingo
>


Thanks Ingo.
