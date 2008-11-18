Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbYKRQxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbYKRQxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYKRQxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55460 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYKRQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:53:09 -0500
Date: Tue, 18 Nov 2008 11:53:06 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun
 field
In-Reply-To: <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811181151010.15003@gandalf.stny.rr.com>
References: <20081117084923.GD28786@elte.hu> <20081118084755.GK17838@elte.hu>  <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com>  <20081118145154.GC30358@elte.hu>  <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>  <20081118151326.GH30358@elte.hu>
  <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>  <20081118155045.GJ30358@elte.hu>  <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>  <20081118164019.GA18620@elte.hu> <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Fr?d?ric Weisbecker wrote:

> 2008/11/18 Ingo Molnar <mingo@elte.hu>:
> > Would be nice to have the dynamic allocation straight away
> 
> 2008/11/18 Steven Rostedt <rostedt@goodmis.org>:
> > I would recommend using a static array
> 
> :-)

How about a compromise, start off the patch series getting it working with 
task struct static array, and then finish the series with the dynamic 
array.

This is my development model, because it lets me know where the bugs are 
better. If we find some strange bug, this can help pin point via a bisect 
if the bug is with the general code, or with the use of a dynamic array.

Just my preference ;-)

-- Steve

