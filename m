Return-Path: <linux-kernel-owner+w=401wt.eu-S932159Ab0AUK7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0AUK7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 05:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128Ab0AUK7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 05:59:48 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57706 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0AUK7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 05:59:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B/PLjS/c+lAXHSzu3AByiH+Wj5A8KGWL8vyi7363afUUCbZIVtcOrCl4B3wXxEcLXr
         NQ9ud+8VSPpqHloG2M3R/IFJu9uqzNIEM3QCZWAuY1wDi1K9o02/tBJa/1WRHRSpFHeW
         WWI4zxrx+dC9a1b46/XsHwWKPpKzy+9JVpehg=
Date: Thu, 21 Jan 2010 11:59:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Julia Lawall <julia@diku.dk>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
Message-ID: <20100121105940.GC5017@nowhere>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com> <Pine.LNX.4.64.1001192155490.28583@ask.diku.dk> <1263935333.4561.26.camel@frodo> <Pine.LNX.4.64.1001211145480.13529@ask.diku.dk> <20100121105311.GB5017@nowhere> <1264071413.4283.1155.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264071413.4283.1155.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 11:56:53AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-21 at 11:53 +0100, Frederic Weisbecker wrote:
> 
> > Looks fine as spin_unlock includes a memory barrier, IIRC.
> 
> It doesn't actually, see Documentation/memory-barriers.txt
> 


Doh!

