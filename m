Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZIUNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZIUNJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZIUNJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:09:21 -0400
Received: from s-utl01-sjpop.stsn.net ([72.254.0.201]:63398 "HELO
	s-utl01-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756040AbZIUNJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:09:20 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 09:09:20 EDT
Subject: Re: TRACE_EVENT_ABI ?
From: Steven Rostedt <rostedt@goodmis.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu
In-Reply-To: <20090921093652.0722d745@infradead.org>
References: <20090921093652.0722d745@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 21 Sep 2009 08:42:19 -0400
Message-Id: <1253536939.2630.3.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:36 +0200, Arjan van de Ven wrote:
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

I don't know what you've done so far, but can't you simply in
tracepoint.h define:

#define TRACE_EVENT_API(a,b,c,d,e) TRACE_EVENT(a,b,c,d,e)

And every time TRACE_EVENT_API is used, it will simply do whatever
TRACE_EVENT is at that time?

I've done similar tricks with other code.

-- Steve



