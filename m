Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbZJGECA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbZJGECA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbZJGEB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:01:59 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:62161 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbZJGEB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HQsPTw21iEaYNyo3IVnGcQmmKG4y8LGizWv/9oG93krYByBkhulukIjptdzb8uZ8kY
         F/MXz1t26gz3D5T2MESPNGe5sXmJpcvgSW5ZN2pHWtLrs2RWdTbyfNcZIkF1fYig+/e3
         ZshKCltlCAmfNqaG+HqGtl7hJENp7GAHULr/U=
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose
 scripting
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
In-Reply-To: <20091006090954.GA19325@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <20091006090954.GA19325@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 23:01:20 -0500
Message-Id: <1254888080.28917.112.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 11:09 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Known problems/shortcomings:
> > 
> > Probably the biggest problem right now is the sorting hack I added as 
> > the last patch.  It's just meant as a temporary thing, but is there 
> > because tracing scripts in general want to see events in the order 
> > they happened i.e. timestamp order. [...]
> 
> Btw., have you seen the -M/--multiplex option to perf record? It 
> multiplexes all events into a single buffer - making them all ordered. 
> (The events are in causal ordering in this case even if there's some TSC 
> asynchronity)
> 

No, I didn't know about that - thanks for letting me know.

Tom

> 	Ingo

