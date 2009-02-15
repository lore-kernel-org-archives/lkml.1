Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZBOS7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZBOS7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZBOS6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:58:52 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33053 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZBOS6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:58:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=oSLT7li0IQO0Svs6EGhCk5QazMG/R33wgm/mi2zWl2XGPIH3uEmQ/YKqbrk59pFwp0
         h7cIFrP2hT5NK/Qzq5fUWcpo7vSuZMQcwavAgtwCxcpoB3WGABQP1D18vp73VfcGtFkx
         QhaAoCTUIY764XDQszzLs+pPP53c5t3fHD4Xo=
Date: Sun, 15 Feb 2009 20:58:46 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: updates for 2.6.29
Message-ID: <20090215205846.4d96260b@daedalus.pq.iki.fi>
In-Reply-To: <20090111030641.GJ7077@elte.hu>
References: <20090109002747.240318148@goodmis.org>
	<20090111030641.GJ7077@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009 04:06:41 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: tip/devel
> > 
> > 
> > Pekka Paalanen (3):
> >       doc: mmiotrace.txt, buffer size control change
> >       trace: mmiotrace to the tracer menu in Kconfig
> >       mmiotrace: count events lost due to not recording
> > 
> > ----
> >  Documentation/tracers/mmiotrace.txt |    6 ++----
> >  arch/x86/Kconfig.debug              |   24 ++----------------------
> >  kernel/trace/Kconfig                |   23 +++++++++++++++++++++++
> >  kernel/trace/trace_mmiotrace.c      |   14 ++++++++++----
> >  4 files changed, 37 insertions(+), 30 deletions(-)
> 
> pulled into tip/tracing/urgent, thanks Steve!

Hi,

I was just diffing linus/master to Ingo's tip/master, and I see the
"mmiotrace: count events lost due to not recording" being added in
tip/master. The doc and Kconfig updates also, nothing is in linus'.

I thought all these were going into 2.6.29. What happened?

Thanks.
-- 
Pekka Paalanen
http://www.iki.fi/pq/
