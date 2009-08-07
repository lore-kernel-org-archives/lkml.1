Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZHGCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZHGCvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZHGCvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:51:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35121 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZHGCvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:51:18 -0400
Date: Thu, 6 Aug 2009 22:51:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH v2 2/3] tracing/filters: Add __field_ext() to
 TRACE_EVENT
In-Reply-To: <4A7B9559.5000003@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908062251050.2840@gandalf.stny.rr.com>
References: <4A7B9242.7010204@cn.fujitsu.com> <4A7B9272.6050709@cn.fujitsu.com> <alpine.DEB.2.00.0908062242220.2840@gandalf.stny.rr.com> <4A7B9559.5000003@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Aug 2009, Li Zefan wrote:

> >>  #define is_signed_type(type)	(((type)(-1)) < 0)
> >>  
> >> @@ -165,7 +172,7 @@ do {									\
> >>  #define __common_field(type, item, is_signed)				\
> >>  	ret = trace_define_field(event_call, #type, "common_" #item,	\
> >>  				 offsetof(typeof(field.ent), item),	\
> >> -				 sizeof(field.ent.item), is_signed);	\
> >> +				 sizeof(field.ent.item), is_signed, -1);\
> > 
> > I think this wants to be FILTER_OTHER?
> > 
> 
> oops.. I thought I had changed all -1 to FILTER_OTHER..
> 
> I guess you're going to fix this manually?

Yeah, I can make that change.

Thanks!

-- Steve

