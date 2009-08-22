Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbZHVABA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbZHVABA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 20:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbZHVAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 20:00:59 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:31850 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbZHVAA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 20:00:59 -0400
Date: Fri, 21 Aug 2009 17:02:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, dave@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4 -mm] flex_array: add flex_array_shrink function
Message-Id: <20090821170227.c34eb50e.randy.dunlap@oracle.com>
In-Reply-To: <20090821164935.173689a0.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0908211621160.28611@chino.kir.corp.google.com>
	<20090821164935.173689a0.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A8F3527.00EB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 16:49:35 -0700 Andrew Morton wrote:

> On Fri, 21 Aug 2009 16:21:49 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > +/**
> > + * flex_array_shrink - free unused second-level pages
> > + *
> > + * Frees all second-level pages that consist solely of unused
> > + * elements.  Returns the number of pages freed.
> > + *
> > + * Locking must be provided by the caller.
> > + */
> > +int flex_array_shrink(struct flex_array *fa)
> 
> It's logical but afaik unconventional that none of the flex_array
> kerneldoc actually documents the `struct flex_array *fa' argument.

IF (big if) someone had used "make htmldocs" and checked it for errors/warnings,
(see 11. in Documentation/SubmitChecklist), this would have been flagged with:

Warning(some_filename.c:1012): No description found for parameter 'fa'


> We're all waiting with bated breath to see who will be the first to use
> flex_array in live code.
> 
> Sometime we'll need to move flex_array.o from lib-y to obj-y and fill
> it up with EXPORT_SYMBOL()s.  2.6.32 I expect.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
