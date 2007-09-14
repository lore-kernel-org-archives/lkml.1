Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbXINScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbXINScr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXINSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbXINScg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:32:36 -0400
Subject: Re: [git patches] net driver fixes
From: Dan Williams <dcbw@redhat.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46EAD049.4020107@garzik.org>
References: <20070913053022.GA16891@havoc.gtf.org>
	 <1189793598.2508.4.camel@xo-3E-67-34.localdomain>
	 <46EAD049.4020107@garzik.org>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 14:31:17 -0400
Message-Id: <1189794677.2508.19.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 14:17 -0400, Jeff Garzik wrote:
> Dan Williams wrote:
> > WTF?  why would the default be to _not_ propagate carrier state?  Are
> > there some mitigating circumstances that require this driver to not
> > notify the stack of carrier on/off?  Userspace stuff really should know
> > about the carrier state, and this disables it by default.
> 
> 
> The commit explains that...

I admit that I probably don't understand the system architecture of
where ehea would be used, but would this
cause /sys/class/net/ethX/carrier to be TRUE even if the device has no
carrier?  That seems quite wrong IMHO.  When does ehea not have a
carrier?  And in that case, does sysfs say 1 or 0 for the carrier?

Dan


