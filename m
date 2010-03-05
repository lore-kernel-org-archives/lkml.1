Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0CEHQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:16:10 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:44090 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab0CEHQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruedhLfO32P27/rS3rsgS9y471/u/Dt2YvHRLJxf3mSeo5r0YsWVAoMh8LV0npLKht
         bHGfx5Qc9leiJ0dPxdgOYJPFrF+5HumuxkZzz7XP5U9krGNm8+CJT6kekJ8+WnYIqBMy
         JHQQiGMWU392+mkXMlmgMSqBMWRpvzO0PLwQY=
MIME-Version: 1.0
In-Reply-To: <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
Date: Fri, 5 Mar 2010 15:16:07 +0800
Message-ID: <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
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

On Fri, Mar 5, 2010 at 12:14 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Thu, Mar 4, 2010 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
>>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
>>> the soft lockup. On my machine, it is pretty easy, just run:
>>>
>>> echo function_graph > current_tracer
>>>
>>> I found this when 2.6.33-rc7, but forgot to report here. I just tried
>>> today's
>>> Linus tree, it still has this problem.
>>
>> So this is not present in 2.6.33-rc6? If you know approximately when it
>> appeared, would you be able to do a git bisect on it?
>>
>
> I can't say that because I didn't try -rc6.
>

Sigh, 2.6.33-rc6 doesn't work, even 2.6.32 doesn't work...
