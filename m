Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYKFRpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYKFRpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKFRp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:45:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:60960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYKFRpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:45:25 -0500
Date: Thu, 6 Nov 2008 09:45:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
Message-ID: <20081106094558.50d94bcc@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com>
References: <20081105094902.27ec4b39@infradead.org>
	<1225976138.7803.4485.camel@twins>
	<20081106060624.58a0f967@infradead.org>
	<1225981141.7803.4577.camel@twins>
	<20081106063108.02b4813d@infradead.org>
	<1225983052.7803.4623.camel@twins>
	<20081106070157.065b2dcc@infradead.org>
	<alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 10:34:50 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> What I would like is a single "event tracer" that does all of this.
> But add the ability to start and stop different events. We could start
> with this tracer, and then add more events to this tracer. Have a
> separate file to show which events are available.
> 
> This will keep the 'available_tracers' file small, but it would be
> fine if the 'events' file grew large.

well 2 ounces versus one liter ;)


what is the real need is
1) Have a trace point in the source
2) Associate a "formatting function" with that point 
   (which basically transforms the trace parameters to, say, a string)
3) A way to turn the trace point on/off.

right now this is what the fsync tracer does, because it's the only way
to do such a thing.
I don't care how to otherwise do it ....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
