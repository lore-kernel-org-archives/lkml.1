Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZLKRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZLKRof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZLKRoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:44:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:14204 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZLKRo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Oz/FSVCTZ7QPKMcd4g80YFgYeG/oEbtzUH7jZVkKwnL9jSLaME3M4Juq7Qow2pDF5z
         lO03FgOMLrv8VAnzUlVUXlTMnKD4GDIqGx+Dw88uwa7CscZQBdc+5LhUcCVpF1W8uAW1
         Nq7ub9z/4lwCxXY29e8arEMD9qTl59lY6MfY8=
Date: Fri, 11 Dec 2009 18:44:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: add checks for printing graph irq
Message-ID: <20091211174425.GB5094@nowhere>
References: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com> <20091211111946.GC5244@nowhere> <1260543650.2146.358.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260543650.2146.358.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:00:50AM -0500, Steven Rostedt wrote:
> On Fri, 2009-12-11 at 12:19 +0100, Frederic Weisbecker wrote:
> > On Fri, Dec 11, 2009 at 05:38:35PM +0800, Wenji Huang wrote:
> > > Check return value of trace_seq_printf.
> > > 
> > > Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> > > ---
> > 
> > 
> > I'm applying it, I'll send the fix for the problem you've reported
> > at the same time.
> 
> As for my comment to the patch. Please do not apply this.
> 
> Thanks,


Ok. Yeah you're right, the seq buffer will refuse them once
it's fullfilled anyway, so only the last check matters, we have
too much of these checks in the current code.

