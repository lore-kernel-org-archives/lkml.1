Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZHGDbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZHGDbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbZHGDbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:31:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65389 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZHGDbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:31:03 -0400
Date: Thu, 6 Aug 2009 23:31:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/filters: Support filtering for char *
 strings
In-Reply-To: <4A7B9E6B.2090202@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908062328140.2840@gandalf.stny.rr.com>
References: <4A7A72BD.5030201@cn.fujitsu.com> <4A7A72FA.9040102@cn.fujitsu.com> <alpine.DEB.2.00.0908061020240.9870@gandalf.stny.rr.com> <4A7B8149.3070901@cn.fujitsu.com> <alpine.DEB.2.00.0908062251230.2840@gandalf.stny.rr.com> <4A7B9BB5.3040005@cn.fujitsu.com>
 <alpine.DEB.2.00.0908062321420.2840@gandalf.stny.rr.com> <4A7B9E6B.2090202@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Aug 2009, Li Zefan wrote:

> Steven Rostedt wrote:
> > Ah, so the answer I'm looking for is:
> > 
> > The filtering will not dereference "char *" unless the developer 
> > explicitly sets FILTER_PTR_STR in __field_ext.
> > 
> > Is this above statement correct?
> > 
> 
> Exactly. Sorry that I didn't explain it clearly in the
> first place. :)

No problem. It is quite often that things so blatantly obvious to a 
developer is totally foreign for the observer, that the simple explanation 
is commonly overlooked.

I'll pull in your patches, with the -1 update, as well as adding my 
above statement to this patch's change log.

I'll queue it for 32.

Thanks!

-- Steve

