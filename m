Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXEOXhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXEOXhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbXEOXhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:37:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20655 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbXEOXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:37:47 -0400
Date: Tue, 15 May 2007 16:41:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: How to force Kconfig tristate into range n..m?
Message-Id: <20070515164130.77ff2962.randy.dunlap@oracle.com>
In-Reply-To: <20070515233002.GA9614@linux.vnet.ibm.com>
References: <20070515233002.GA9614@linux.vnet.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 16:30:02 -0700 Paul E. McKenney wrote:

> Hello!
> 
> It would be nice to constrain RCU_TORTURE_TEST to "n" or "m", excluding
> "y", since "y" gives anti-social results that I have never seen a use
> for.  So I tried adding a "range n m" to the Kconfig.debug entry for
> RCU_TORTURE_TEST.  This gives me the following warning at "make xconfig"
> time:
> 
>    lib/Kconfig.debug:386:warning: range is only allowed for int or hex symbols
> 
> and xconfig ignores the restriction.
> 
> A few clumsy hacks get rid of the error message, but fail to cause
> xconfig to enforce the limit.
> 
> Is there some other way to prohibit modules from being compiled into
> the main kernel?

I think that
	depends on m
will do what you want.  That's what some ancient PCMCIA drivers
do, as well as the crypto test module.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
