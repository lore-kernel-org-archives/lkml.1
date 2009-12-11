Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZLKOyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZLKOyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbZLKOy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:54:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50596 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbZLKOy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:54:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=WZeMiI-TzpjYBeJ1Oa8A:9 a=WFylIFMHlnspYg_09VfoxbwBkPcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: dynamic ftrace - graph
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4B2259EB.80605@monstr.eu>
References: <4AF848C0.7010807@monstr.eu>
	 <1260506225.2146.347.camel@gandalf.stny.rr.com>
	 <4B21F4F6.5080600@monstr.eu>
	 <1260542255.2146.350.camel@gandalf.stny.rr.com>  <4B2259EB.80605@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 09:54:32 -0500
Message-ID: <1260543272.2146.355.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 15:40 +0100, Michal Simek wrote:
> Steven Rostedt wrote:

> > Hey, if they work and they are only in your arch, then I'm fine with
> > them ;-)
> 
> yeah. There is one just small hook to recordmcount.pl. :-)

I may need to give an acked-by. If I did not yet, could you send me that
specific patch.

> 

> we will see. Currently I have small problem only with irqsoff but I 
> think this don't have connection with ftrace - only with lockdep I 
> think. :-)

You have lockdep working?  If you get lockdep working you should get the
irqsoff tracer for free.

-- Steve


