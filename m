Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZCVSPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZCVSPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 14:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZCVSPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 14:15:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZCVSPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 14:15:17 -0400
Date: Sun, 22 Mar 2009 14:15:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 2/4] tracing: add ring_buffer_event_discard() to ring
 buffer
In-Reply-To: <1237742701.7703.53.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903221414370.3578@gandalf.stny.rr.com>
References: <1237710649.7703.47.camel@charm-linux>  <20090322141435.GA29751@elte.hu> <1237742701.7703.53.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Tom Zanussi wrote:

> 
> On Sun, 2009-03-22 at 15:14 +0100, Ingo Molnar wrote:
> > * Tom Zanussi <tzanussi@gmail.com> wrote:
> > 
> > > This patch overloads RINGBUF_TYPE_PADDING to provide a way to discard
> > > events from the ring buffer, for the event-filtering mechanism
> > > introduced in a subsequent patch.
> > > 
> > > I did the initial version but thanks to Steven Rostedt for adding the
> > > parts that actually made it work. ;-)
> > 
> > I suspect it's signed-off-by both of you?
> > 
> 
> Oops, yeah, here's mine:
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

Since some of the code was mine too, here's my

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

In case I did not sign it off before.

-- Steve

