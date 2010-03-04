Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0CDNyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:54:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0CDNyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:54:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Vqlk9IDV8gZJmW6E3goA:9 a=rrc0cJSkexMvhqlbvzLsyC7rO7QA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 04 Mar 2010 08:54:07 -0500
Message-ID: <1267710847.10871.102.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
> I am not sure if this is ftrace's fault, but it is ftrace who triggers
> the soft lockup. On my machine, it is pretty easy, just run:
> 
> echo function_graph > current_tracer
> 
> I found this when 2.6.33-rc7, but forgot to report here. I just tried
> today's
> Linus tree, it still has this problem.

So this is not present in 2.6.33-rc6? If you know approximately when it
appeared, would you be able to do a git bisect on it?

Thanks,

-- Steve

