Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0CDC6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:58:50 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:64982 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0CDC6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:58:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PIB+nriiJ6ZqXxQAEBKuhrNeuZiquv4gqFlh/NzQ5fieI/iVuSs5YRw5mdjpRsm8Ir
         kopn6ZD8jjS5OwfcVY5QMZummXIrqOGqX6zJy+/GShgEjjUfs46gG0Y4LzlQcTq90fMo
         Du6YPqMu4zh7/+Ng5TpZ4NzvX8NhzSnwSU26o=
MIME-Version: 1.0
In-Reply-To: <1267621558.10871.29.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267621558.10871.29.camel@gandalf.stny.rr.com>
Date: Thu, 4 Mar 2010 10:58:44 +0800
Message-ID: <2375c9f91003031858g87fa483t297417f4d6af063b@mail.gmail.com>
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

On Wed, Mar 3, 2010 at 9:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
>> Hi, Steven, Frederic, Ingo,
>>
>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
>> the soft lockup. On my machine, it is pretty easy, just run:
>>
>> echo function_graph > current_tracer
>>
>> I found this when 2.6.33-rc7, but forgot to report here. I just tried today's
>> Linus tree, it still has this problem.
>>
>> Attached are the full soft lockup warnings.
>>
>> Below is my related configs:
>
> Actually this is not enough for me. Could you send me the full config,
> as well as the full dmesg, not just the dump.
>

Full dmesg: http://pastebin.ca/1822197
Full config: http://pastebin.ca/1822201

Note, I changed some tracing unrelated config after getting that soft lockup,
so it would not matter.
