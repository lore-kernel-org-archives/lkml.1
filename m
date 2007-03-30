Return-Path: <linux-kernel-owner+w=401wt.eu-S1751349AbXC3TUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbXC3TUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXC3TUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:20:00 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:16186 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbXC3TT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:19:59 -0400
Subject: Re: [PATCH 8/9] clocksource: s390 initialize list value
From: Daniel Walker <dwalker@mvista.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com
In-Reply-To: <20070330190905.GB13240@osiris.ibm.com>
References: <20070330184541.583153763@mvista.com>
	 <20070330184616.107636073@mvista.com>
	 <20070330190905.GB13240@osiris.ibm.com>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 12:19:18 -0700
Message-Id: <1175282358.12252.179.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 21:09 +0200, Heiko Carstens wrote:
> On Fri, Mar 30, 2007 at 11:45:49AM -0700, Daniel Walker wrote:
> > Update arch/s390 with list initialization.
> > 
> > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > 
> > ---
> >  arch/s390/kernel/time.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6.20/arch/s390/kernel/time.c
> > ===================================================================
> > --- linux-2.6.20.orig/arch/s390/kernel/time.c
> > +++ linux-2.6.20/arch/s390/kernel/time.c
> > @@ -314,6 +314,7 @@ static struct clocksource clocksource_to
> >  	.mult		= 1000,
> >  	.shift		= 12,
> >  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> > +	.list		= LIST_HEAD_INIT(clocksource_tod.list),
> >  };
> 
> Why? This doesn't fix anything...

It's needed for patch 9/9 in the series.

Daniel

