Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZKTI1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZKTI1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZKTI1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:27:12 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:53713 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZKTI1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:27:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EAjM2MA9qt8Hmu29RF6DlSUbXwDuQ7ETkGr8UMsl4RQqxPayiwR2IoOpwTqBV6Sow0
         uLfZ1wKn8B0IamHlsWOBl1FEbHaT43b2eK9oCO05cO5KN2bb8kM4NwR3UKSUIoKiUrYx
         dBdur8FOFnAY2aOmhv1Fft5xgBynm++s0c70Q=
MIME-Version: 1.0
In-Reply-To: <4B065241.5040901@cn.fujitsu.com>
References: <4B064AF5.9060208@cn.fujitsu.com> <4B064B0B.30207@cn.fujitsu.com>
	 <4B065145.2000709@cs.helsinki.fi> <4B065241.5040901@cn.fujitsu.com>
Date: Fri, 20 Nov 2009 10:27:16 +0200
X-Google-Sender-Auth: 4182403a4d02b409
Message-ID: <84144f020911200027m6ac15e48laf95f7f3f8a92e3d@mail.gmail.com>
Subject: Re: [PATCH 2/2] tracing: Remove kmemtrace tracer
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:24 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> 于 2009年11月20日 16:20, Pekka Enberg 写道:
>> Li Zefan kirjoitti:
>>> The kmem trace events can replace the functions of kmemtrace
>>> tracer.
>>>
>>> And kmemtrace-user can be modified to use trace events.
>>> (But after cloning the git repo, I found it's still based on
>>> the original relay version..), not to mention now we have
>>> 'perf kmem' tool.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>
>> NAK for the time being. "perf kmem" output is not yet as good as that of
>> kmemtrace-user.
>>
>
> But is the current kmemtrace-user based on kmemtrace?
>
> From the git repo:
>        http://repo.or.cz/w/kmemtrace-user.git
>
> I found it's still based on relay.

The "ftrace-temp" branch seems to have the ftrace based version in it. Eduard?

                      Pekka
