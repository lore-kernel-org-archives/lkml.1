Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0CICkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:40:08 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:49665 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0CICkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VrWWurMrD2Iiww0CXYygWz4/qya6RAHiPvVVm60bOntGxTQt6kYQomzvqgVS6OMLnK
         /y1YwvCpdZdi5up4zakJGGVz2KIhkevyDXaV0oW2k+81TYch19CSMsjEvS56Jhn2C1LQ
         5TCUVrXzh1Fgohcj+2iqI6q3jyUMxrWu+tNnA=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003071831x4104dd8dp82967c0409391bd5@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <2375c9f91003071831x4104dd8dp82967c0409391bd5@mail.gmail.com>
Date: Tue, 9 Mar 2010 10:40:04 +0800
Message-ID: <2375c9f91003081840w5419d847q8ffd8b6ce46d86fb@mail.gmail.com>
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 10:31 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Mar 5, 2010 at 11:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> Now some things you can do to help performance. One is not to trace
>> functions that are known to have a high hit rate. You can do this with
>> the set_ftrace_notrace file, or add "ftrace_notrace=func1,func2,func3"
>> to the command line where func1,func2,func3 are the functions you do not
>> want to trace. This just adds these by default to the set_ftrace_notrace
>> and can be removed at runtime.
>>
>>
>> The functions I commonly write to are:
>>
>> echo '*spin_lock*' '*spin_unlock*' '*spin_try*' '*rcu_read*' > set_ftace_notrace
>>
>> since these functions are hit quite intensively, by not tracing them it
>> helps a bit with performance.
>
> I will try this now.
>

Unfortunately, this doesn't help.

What is worse, I got another soft lockup, although I already turned LOCKDEP off.


Thanks.
