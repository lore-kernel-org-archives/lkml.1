Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZLDVBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZLDVBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZLDVBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:01:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56422 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbZLDVBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X6xjZiL+GfIr2xsGJW0ImQZf375c6BFA4DK8GxaUC9tgtV6o9Q2iG6yFF8HMio4Hyt
         sv/z/QIqQGwe6w/xzEEeoHVEv2tkgyqbL+m10hh3pXKXKRPkrWLR4npYih5gVxC3VKuU
         5bAkuMN8Q6GJ7wFm9XF+83xqbxvxbmrXmnjBU=
Date: Fri, 4 Dec 2009 22:02:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf events: Remove unused struct
	perf_event::event_callback
Message-ID: <20091204210149.GB13473@nowhere>
References: <1259882557-12024-1-git-send-regression-fweisbec@gmail.com> <1259916490.3977.1661.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259916490.3977.1661.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:48:10AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-12-04 at 00:22 +0100, Frederic Weisbecker wrote:
> 
> > @@ -671,8 +671,6 @@ struct perf_event {
> >  
> >  	perf_callback_t			callback;
> 
> Any chance we can get all of that perf_callback_t ugly gone?


Sure. We had callback and event_callback.
event_callback is removed in this patch and overflow_handler will
soon replace the callback field.

