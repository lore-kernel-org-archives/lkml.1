Return-Path: <linux-kernel-owner+w=401wt.eu-S1764805AbXIXRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764805AbXIXRGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbXIXRGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:06:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56814 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbXIXRGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:06:12 -0400
Date: Mon, 24 Sep 2007 22:46:24 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org,
       dhaval@linux.vnet.ibm.com, containers@lists.osdl.org,
       kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, efault@gmx.de
Subject: Re: [PATCH 4/5] Add fair-user scheduler
Message-ID: <20070924171624.GH5657@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070924163326.GA10291@linux.vnet.ibm.com> <20070924164059.GE10291@linux.vnet.ibm.com> <20070924095641.12e595b3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924095641.12e595b3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 09:56:41AM -0700, Randy Dunlap wrote:
> > +choice
> > +	depends on FAIR_GROUP_SCHED
> > +	prompt "Basis for grouping tasks"
> > +	default FAIR_USER_SCHED
> > +
> > + 	config FAIR_USER_SCHED
> > + 		bool "user id"
> > + 		help
> > + 		  This option will choose userid as the basis for grouping
> > +		  tasks, thus providing equal cpu bandwidth to each user.
> 
> s/cpu/CPU/g please.

ok, sure.

> and the "bool", "help" and help text are indented by one tab too much.

will take care.

-- 
Regards,
vatsa
