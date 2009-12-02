Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZLBXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZLBXNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZLBXNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:13:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbZLBXNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:13:20 -0500
Subject: Re: trace/events: DECLARE vs DEFINE semantic
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       wcohen@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
       jbaron@redhat.com, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <4B16F389.4090801@zytor.com>
References: <20091202144334.GA30359@elte.hu>
	 <1259765735.12870.42.camel@gandalf.stny.rr.com>
	 <20091202162715.GB9710@Krystal>
	 <1259773888.12870.61.camel@gandalf.stny.rr.com>
	 <20091202180633.GF9710@Krystal>
	 <1259777987.12870.70.camel@gandalf.stny.rr.com>
	 <20091202190135.GA23316@Krystal>
	 <1259781578.12870.78.camel@gandalf.stny.rr.com>
	 <4B16EC06.6010706@redhat.com>
	 <1259794005.12870.102.camel@gandalf.stny.rr.com>
	 <20091202225736.GA14770@Krystal>  <4B16F389.4090801@zytor.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 02 Dec 2009 18:13:25 -0500
Message-Id: <1259795605.12870.104.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 15:08 -0800, H. Peter Anvin wrote:
> On 12/02/2009 02:57 PM, Mathieu Desnoyers wrote:
> >>
> >> TRACE_CLASS - Declares a class
> >> TRACE_CLASS_EVENT - defines an event for said class
> >> TRACE_EVENT - Declares a class and defines an event (as is today)
> > 
> > Yep, it looks good! It's self-descriptive and don't require to explain
> > what the thing is doing each time we refer to it. (however I feel a bit
> > sad for Fred, Wilma and Barney) ;)
> > 
> 
> Although you have to admit it's a bit confusing that:
> 
> TRACE_EVENT = TRACE_CLASS + TRACE_CLASS_EVENT
> 
> ... as opposed to ...
> 
> TRACE_CLASS_EVENT = TRACE_CLASS + TRACE_EVENT

Fred, Wilma and Barney are sounding better by the second.

So, would you think:

TRACE_CLASS - Declare a class
TRACE_EVENT - defines an event for said class (different meaning than before)
TRACE_CLASS_EVENT - Declares a class and an event

is the better naming?

-- Steve


