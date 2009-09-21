Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZIUN0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZIUN0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbZIUN0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:26:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbZIUN0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:26:39 -0400
Date: Mon, 21 Sep 2009 09:26:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
Subject: Re: TRACE_EVENT_ABI ?
In-Reply-To: <20090921093652.0722d745@infradead.org>
Message-ID: <alpine.DEB.2.00.0909210926010.7647@gandalf.stny.rr.com>
References: <20090921093652.0722d745@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Resending due to wrong SMTP server ]


On Mon, 21 Sep 2009, Arjan van de Ven wrote:

> Hi,
> 
> Ingo suggested to make a TRACE_EVENT_ABI, which is equivalent in
> implementation to TRACE_EVENT, except that it signals a stable
> interface.
> 
> In trying to implement this I'm running into a wall where TRACE_EVENT
> keeps being defined in many different ways all over the place, making
> this a really nasty hack to make it just an alias.
> 
> Do you have any clever ideas on how to make this an alias without
> fouling up the whole tracing system?
> 

I don't know what you've done so far, but can't you simply in
tracepoint.h define:

#define TRACE_EVENT_API(a,b,c,d,e) TRACE_EVENT(a,b,c,d,e)

And every time TRACE_EVENT_API is used, it will simply do whatever
TRACE_EVENT is at that time?

I've done similar tricks with other code.

-- Steve



