Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYEVRn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYEVRn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYEVRnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:43:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbYEVRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:43:18 -0400
Date: Thu, 22 May 2008 13:43:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, proski@gnu.org,
       sandmann@redhat.com, a.p.zijlstra@chello.nl,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: limit use of check pages
In-Reply-To: <20080522203800.47366817@daedalus.pq.iki.fi>
Message-ID: <Pine.LNX.4.58.0805221342350.14724@gandalf.stny.rr.com>
References: <20080522042215.584408893@goodmis.org> <20080522042301.622087604@goodmis.org>
 <20080522203800.47366817@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2008, Pekka Paalanen wrote:

> On Thu, 22 May 2008 00:22:16 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > +#define CHECK_COND(cond)			\
> > +	if (unlikely(cond)) {			\
> > +		tracing_disabled = 0;		\
>
> -----------------------------------^
> This looks like a typo.
>
> I also quickly read through the other patches and didn't see any
> obvious problems in them.

Indeed it is! I haven't hit the cond so I wouldn't have seen it in my
tests ;-)

Thanks!

-- Steve

