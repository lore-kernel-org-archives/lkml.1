Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0CEEOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:14:55 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:64544 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab0CEEOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:14:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q6RrZ11wYFt34CaSbL/scAlIsyWlXCONUjO5ncjp0SGN3wkt6k8zicGGT1J49lLLDp
         kd2UomSmiB1kg+pXgdJN/hsjtYEb0abZ+GQSymDMu2hwN4eze594Z/Vkie/sg4+jNupn
         aARl+X7JmiVARi/LVo/JnYonnqkwgcXXbrPGw=
MIME-Version: 1.0
In-Reply-To: <1267710847.10871.102.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
Date: Fri, 5 Mar 2010 12:14:52 +0800
Message-ID: <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
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

On Thu, Mar 4, 2010 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
>> the soft lockup. On my machine, it is pretty easy, just run:
>>
>> echo function_graph > current_tracer
>>
>> I found this when 2.6.33-rc7, but forgot to report here. I just tried
>> today's
>> Linus tree, it still has this problem.
>
> So this is not present in 2.6.33-rc6? If you know approximately when it
> appeared, would you be able to do a git bisect on it?
>

I can't say that because I didn't try -rc6.

Ok, let me try to do a bisect, but since weekend is coming, I can't do
any testing during weekend, so will try it next Monday.

Thanks!
