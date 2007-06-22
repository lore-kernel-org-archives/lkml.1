Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbXFVXiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbXFVXiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXFVXiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:38:08 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:35209 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXFVXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k8WpECPv8yy+eDTYfzuBSm1Ko/cE8C99p4ui+y5hyFUmt/VbWCoeC/YF3Opk7dchmsQV6fA/z6IH9MnZw7/WxSQKOsL8gT3Y4EM+3BBEGnds3eM38v69zgQIpdBU6qBZ8hA1Ltp5k3xSRMrjpMaCOCq0r9045zxYEFYA3La6DQY=
Message-ID: <21d7e9970706221638n8e8c6dco20ffb5beb80ef3ae@mail.gmail.com>
Date: Sat, 23 Jun 2007 09:38:05 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>, "Arnd Bergmann" <arnd@arndb.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Daniel Walker" <dwalker@mvista.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 4/6] Make DRM use the tasklet is-sched API
In-Reply-To: <20070622182411.GA17658@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <1182494169.3228.11.camel@dhcp193.mvista.com>
	 <1182494960.20203.34.camel@chaos> <200706221810.56298.arnd@arndb.de>
	 <20070622182411.GA17658@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > The drm_locked_tasklet() function seems to have multiple bugs anyway,
> > so getting rid of it can only help, and it avoids exporting a new
> > tasklet_is_scheduled() interface.
>
> That's exactly what I though when looking over this code.  There's
> some really crappy in code in that area, and it should simply be
> rewritten.

Can someone submit a patch or even a better review? btw removing the
core stuff and putting it i915 isn't acceptable, I'll have support for
this feature for other hw coming up so the generic code needs to be
available...

Dave.
