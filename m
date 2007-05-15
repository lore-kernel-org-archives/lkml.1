Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbXEOXao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbXEOXao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760696AbXEOXaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:30:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37108 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760606AbXEOXaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:30:06 -0400
Date: Tue, 15 May 2007 16:30:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, ak@suse.de
Subject: How to force Kconfig tristate into range n..m?
Message-ID: <20070515233002.GA9614@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

It would be nice to constrain RCU_TORTURE_TEST to "n" or "m", excluding
"y", since "y" gives anti-social results that I have never seen a use
for.  So I tried adding a "range n m" to the Kconfig.debug entry for
RCU_TORTURE_TEST.  This gives me the following warning at "make xconfig"
time:

   lib/Kconfig.debug:386:warning: range is only allowed for int or hex symbols

and xconfig ignores the restriction.

A few clumsy hacks get rid of the error message, but fail to cause
xconfig to enforce the limit.

Is there some other way to prohibit modules from being compiled into
the main kernel?

						Thanx, Paul
