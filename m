Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYHSR6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYHSR6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYHSR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:57:56 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:45762 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYHSR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=cBpz22HGQbxfM0OpDs0z8D2yUTv5yd3sL+qnGdVNtwFVIKj2eRMEb0tOx4vIPhtsid
         oONOFU601TLzcUqb27OuLi5y5Kh9TewjPMc/mIZlFqIP6ifDpL7iiP83eHrFQosl1LNT
         kv3c2zi1DWiUnR0LlORjvqmPoN7RDM5qEND24=
Date: Tue, 19 Aug 2008 20:54:40 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       mpm@selenic.com, tglx@linutronix.de, rostedt@goodmis.org,
       cl@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       tzanussi@gmail.com
Subject: Re: [PATCH 1/5] Revert "kmemtrace: fix printk format warnings"
Message-ID: <20080819175440.GA5435@localhost>
References: <1219167807-5407-1-git-send-email-eduard.munteanu@linux360.ro> <Pine.LNX.4.64.0808191049260.7877@shark.he.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808191049260.7877@shark.he.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 10:51:32AM -0700, Randy.Dunlap wrote:
> On Tue, 19 Aug 2008, Eduard - Gabriel Munteanu wrote:
> 
> > This reverts commit 79cf3d5e207243eecb1c4331c569e17700fa08fa.
> > 
> > The reverted commit, while it fixed printk format warnings, it resulted in
> > marker-probe format mismatches. Another approach should be used to fix
> > these warnings.
> 
> Such as what?
> 
> Can marker probes be fixed instead?
> 
> After seeing & fixing lots of various warnings in the last few days,
> I'm thinking that people don't look at/heed warnings nowadays.  Sad.
> Maybe there are just so many that they are lost in the noise.

Hi,

Check the next patch in the series, it provides the alternate fix.
I favor this approach more because it involves fewer changes and we
don't have to use things like "%zu" (which make data type size less
apparent).


	Cheers,
	Eduard

