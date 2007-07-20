Return-Path: <linux-kernel-owner+w=401wt.eu-S939039AbXGTPwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939039AbXGTPwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937044AbXGTPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:52:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:19023 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937016AbXGTPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:52:38 -0400
Date: Fri, 20 Jul 2007 08:55:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@novell.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
       "Arthur Jones" <arthur.jones@qlogic.com>,
       "Vasily Tarasov" <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       "Jan Kara" <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
Message-Id: <20070720085501.82715036.randy.dunlap@oracle.com>
In-Reply-To: <200707201032.47545.ak@novell.com>
References: <617E1C2C70743745A92448908E030B2A01FA4327@scsmsx411.amr.corp.intel.com>
	<200707201032.47545.ak@novell.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 10:32:47 +0200 Andi Kleen wrote:

> On Friday 20 July 2007 01:54:51 Luck, Tony wrote:
>  
> > > Tony, perhaps it would make sense to define some common CONFIG
> > > for COMPAT_FOR_U64_ALIGNMENT longer term to make the #ifs for this
> > > case a little less ugly.
> > 
> > Certainly if there is ever a third architecture that needs this the
> > #if mess will be beyond bad.  But with only the two of us we'd trade
> > one ugly #ifdef line here for another half-dozen lines in each of
> > our Kconfig files to define the new term. 
> 
> Half dozens? 
> 
> config COMPAT_FOR_U64_ALIGNMENT
> 	bool
> 	default y

or even
	def_bool y


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
