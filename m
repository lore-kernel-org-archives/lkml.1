Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYBHP5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYBHP5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbYBHP5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:57:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068AbYBHP5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:57:15 -0500
Date: Fri, 8 Feb 2008 10:56:31 -0500
From: Jason Baron <jbaron@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mingo@elte.hu,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] make pr_debug() dynamic - update docs
Message-ID: <20080208155631.GC13650@redhat.com>
References: <20080207211349.GF14732@redhat.com> <20080207132604.ff93b028.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207132604.ff93b028.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 01:26:04PM -0800, Randy Dunlap wrote:
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -1494,6 +1494,11 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			autoconfiguration.
> >  			Ranges are in pairs (memory base and size).
> >  
> > +	pr_debug
> > +			Enables pr_debug() calls if the immediate
> > +			infrastructure has been enabled. These can also be
> > +			switched on/off via /proc/sys/debug/pr_debug.
> 
> Is this actually Enables/disables?
> I.e., is this actually pr_debug=<int> ?
> If so, please document that also.  If not, why not?
> 

The intention is that pr_debug is off by default. If you pass 'pr_debug' at the
command line, it is turned on early in the boot process. I orginally 
implemented it as pr_debug=<int>, but I believe just the string is simpler.

thanks,

-Jason


