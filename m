Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZJLNs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZJLNs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZJLNs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:48:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZJLNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:48:58 -0400
Subject: Re: [PATCH] ftrace: add kernel command line graph function
 filtering
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Stefan Assmann <sassmann@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com>
References: <4AD2DEB9.2@redhat.com>
	 <c62985530910120209t3d263d5eh5aeba14fcecc9072@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 12 Oct 2009 09:46:59 -0400
Message-Id: <1255355219.7113.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 11:09 +0200, Frédéric Weisbecker wrote:
> 2009/10/12 Stefan Assmann <sassmann@redhat.com>:
> > From 894e934e782ddaa33eb6d156d8326cdf479b5f62 Mon Sep 17 00:00:00 2001
> > From: Stefan Assmann <sassmann@redhat.com>
> > Date: Mon, 12 Oct 2009 09:11:47 +0200
> > Subject: [PATCH] ftrace: add kernel command line graph function filtering
> >
> > Add a command line parameter to allow limiting the function graphs that
> > are traced on boot up, when ftrace=function_graph is specified.
> >
> > This patch adds the following command line option:
> > ftrace_graph_filter=function-list
> 
> 
> If we use this parameter, we undoubtedly want to launch the function
> graph tracer.
> I'd then suggest to arm ftrace=function_graph automatically if we have
> ftrace_graph_filter
> set.
> 

Actually, I disagree. I may just be lazy, and want to set up the
function graph to a particular set of functions. It doesn't mean I want
to run the function_graph tracer on boot up.

This is the same reason I don't automatically set up ftrace=function
when the filter and notrace functions are set.

-- Steve


