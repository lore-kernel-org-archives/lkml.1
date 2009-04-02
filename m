Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZDBLrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZDBLrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZDBLrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:47:17 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:63278 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbZDBLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:47:15 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090402113643.GF10828@elte.hu>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl>  <20090402113643.GF10828@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 13:48:09 +0200
Message-Id: <1238672889.8530.5908.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 13:36 +0200, Ingo Molnar wrote:

> > -#define MAX_STACK_DEPTH		255
> > +#define MAX_STACK_DEPTH		254
> >  
> >  struct perf_callchain_entry {
> > -	u64	nr;
> > +	u32	nr, hv, kernel, user;
> >  	u64	ip[MAX_STACK_DEPTH];
> >  };

Oh, and Paul suggested using u16s right after I send it out. So I'll
either send an update or send a incremental in case you already applied
it.

