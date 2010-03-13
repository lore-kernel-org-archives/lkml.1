Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0CMFe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 00:34:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42399 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0CMFeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 00:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pojpztA74KndhagXzrtW4mQ6Rq/Hx3q8l0z6I97jGfz3ys0LoPL4vWuypehrcegiwS
         yyzothW2Np6guqNxhMP7rXHn4S6CFZzGcUOzTH6kNmMAcrsZKMgkO6qtwszp0+r44CsN
         b/DceYdeDNdd+n/FZq/DzXPFD59FU+UOnhEqk=
Date: Sat, 13 Mar 2010 13:37:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
Message-ID: <20100313053733.GD3704@hack>
References: <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com> <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com> <1267801603.10871.1725.camel@gandalf.stny.rr.com> <20100305171614.GC5244@nowhere> <4B94A816.4090608@cn.fujitsu.com> <1268061312.10871.1810.camel@gandalf.stny.rr.com> <4B95AE4E.6060700@cn.fujitsu.com> <1268101394.10871.1861.camel@gandalf.stny.rr.com> <4B95C2AF.7010508@cn.fujitsu.com> <1268446049.4471.787.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268446049.4471.787.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:07:29PM -0500, Steven Rostedt wrote:
>
>Americo,
>
>I still do not know why the function graph tracer is making your system
>unusable. I'll look more into that when I get a chance. So far, I have
>not had any issues on any of my boxes.
>

Oh, in fact, I just tried 2 x86_64 machines, both of them have this
problem.

Sorry that I don't have much time to do bisect, the last kernel that
I tried is 2.6.32-rc6, it is bad too. I will try some older kernels
if I have time.

Thank you.

