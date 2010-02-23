Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0BWBXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:23:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54579 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab0BWBXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:23:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=Lp5yzKHX74QA:10 a=7U3hwN5JcxgA:10 a=UO6_2agIeW3gB2uerpcA:9 a=lt8AlqPWMU-DmfIFhpEA:7 a=PjUNpQEZ0w4T_lgFln4omLqtwLAA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
 function_graph tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <4B832CD1.3010602@am.sony.com>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com>
	 <20100220144302.GB5354@nowhere>
	 <1266850663.24271.4425.camel@gandalf.stny.rr.com>
	 <20100222181705.GF5055@nowhere>  <4B832CD1.3010602@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 22 Feb 2010 20:23:05 -0500
Message-ID: <1266888185.24271.5055.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 17:18 -0800, Tim Bird wrote:

> > Yeah, this is going to optimize both types of tracing. And I would
> > also like to prevent from adding new checks in the common graph
> > tracing if possible. User's cpus and cachelines deserve better :)
> 
> I'll take a look at doing it this way, and see what I come
> up with.  If I can re-use most of trace_graph_entry and
> trace_graph_return (and I don't see why not), it should be
> a pretty small patch.

Yeah, I did something similar with the function pid tracing. When you
select that the function tracer should test pids, it registers the
function that does the pid test, and then if the pid matches, it calls
the original function tracer callback.

-- Steve


