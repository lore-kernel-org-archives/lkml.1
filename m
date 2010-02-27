Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030706Ab0B0TTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:19:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030653Ab0B0TTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:19:44 -0500
X-Authority-Analysis: v=1.0 c=1 a=TaH4jK7ghYAA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=m1q_mS8XJafhhTBQDicA:9 a=5YcSTZj621AnOlBtulgNtDbZoWEA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL] ftrace: Add function names to dangling } in
 function graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <20100227094301.GC31794@elte.hu>
References: <1267230439.6328.149.camel@gandalf.stny.rr.com>
	 <20100227094301.GC31794@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 27 Feb 2010 14:19:42 -0500
Message-ID: <1267298382.6328.176.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 10:43 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> 
> Neat! I think it would read even more C-ish if it was something non-syntactic, 
> like:
> 
> >       0) ! 594.862 us  |              } /* add_wait_queue */
> >       0) ! 603.361 us  |            } /* __pollwait */
> >       0) ! 613.574 us  |          } /* tcp_poll */
> >       0) ! 623.554 us  |        } /* sock_poll */
> 

Yeah, that looks better. I'll write up a patch when I get a chance.

Thanks,

-- Steve


