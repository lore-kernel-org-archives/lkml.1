Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZCWI3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZCWI3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZCWI3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:29:38 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:54299 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbZCWI3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:29:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qwfKW9WAvzcdtEzifEfX8CFtg2IOLji0ByKPHpX6igKNJxz5Wj+M5AGy3FEPgRz1R2
         wk+fCIHbtjVGlRRVGlTr5IqlTvNnuIctL+vJY1Bewi81JAAT/ksE00/crcaQBCQtO+32
         897r3USzMxVIhYy7p4BSD4AQSDYD5JHkJhxLY=
Subject: Re: [PATCH 0/4] tracing: event filtering v2
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20090322195624.GC15002@elte.hu>
References: <1237710626.7703.45.camel@charm-linux>
	 <20090322195624.GC15002@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 03:29:32 -0500
Message-Id: <1237796972.7527.43.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-03-22 at 20:56 +0100, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Hi,
> > 
> > This is version 2 of my patchset adding filtering to the 
> > event-tracing infrastructure.
> > 
> > Changes from the previous version:
> > 
> > - added common_ prefix to the 5 common event fields
> > - ring_buffer_event_discard() fixes from Steven Rostedt
> > - changed 'and' and 'or' for compound filters to '&&' and '||'
> > - fixed a bug in the matching logic 
> > 
> > Everything seems to work ok for me, but I haven't yet gotten 
> > around to changing the awkward UI.  I plan to fix that as soon as 
> > I can i.e. allow complete compound expressions to be specified all 
> > at once, add <, >, <=, >= and parens, etc.  Until then, it should 
> > hopefully be usable for basic filtering.
> 
> Thanks Tom - Frederic and me had a good look and i picked them up 
> into tip:tracing/filters for now and lets see how they hold up in 
> testing. There was one boundary-condition bug Frederic noticed, i 
> fixed that.
> 
> The subsystem level filters are a nice touch. We still have to 
> complete and organize events into a comprehensive, Linux-wide set of 
> tracepoints, so there will be some churn in this area.

Thanks!  I just posted 3 patches fixing some problems I saw while
reviewing the subsystem code as well.

Tom

> 
> 	Ingo

