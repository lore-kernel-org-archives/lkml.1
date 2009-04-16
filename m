Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZDPFfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZDPFfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 01:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZDPFe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 01:34:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:52360 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZDPFe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 01:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uyHrsxZgohvBNOYf1/2MT4n7UZb+WC+tpL7C6ZlB2Wx0nfk8ua3G7o1TzlLEflcAyQ
         D0YIb3lTV7VkReXtSeXszY40FBsbNtw8NfbiSnf4JJ4dYo2Wr99V8UEy4Zk1STmV365G
         EKh3NXgIO7NgNEk/uFvr2+TzhgxMrZ8Vsa/sI=
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
In-Reply-To: <49E681B5.8070505@cn.fujitsu.com>
References: <1239610670.6660.49.camel@tropicana>
	 <20090414205635.GA5968@nowhere> <1239769945.7852.21.camel@tropicana>
	 <20090415162151.GH5989@nowhere>  <49E681B5.8070505@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 00:34:54 -0500
Message-Id: <1239860094.6437.36.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 08:54 +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> >>> Also, is filter_add_pred() supposed to be available for in-kernel
> >>> uses by other tracers or something?
> >> No, the current callers were the only ones I'd planned on (it's not
> >> static because code in trace_events.c needs to call it).  But, do you
> >> see a use for it by other tracers?
> > 
> > 
> > 
> > May be in the future, it's possible that a tracer might want to
> > set filters by itself.
> > But I don't think it has to be fixed now because there are nothing
> > like that for now.
> > 
> > So, no problem :-)
> > 
> 
> If we restricted the mutex in trace_events_filters.c only, all the
> extern functions can be called without lock, and this is what I did
> in my previous patch.
> 

Yeah, that makes sense - I'll post a patch based on yours to do this
shortly...

Tom

> >  
> >>> If this is planned, the locking could be even deeper than my comments.
> 

