Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXHWBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXHWBGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXHWBG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:06:29 -0400
Received: from mailhost.nmt.edu ([129.138.4.52]:37054 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXHWBG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:06:29 -0400
Date: Wed, 22 Aug 2007 19:06:26 -0600
From: Valerie Henson <val@nmt.edu>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Rodrigo Rubira Branco <rrbranco@br.ibm.com>,
       Brian Twichell <twichell@us.ibm.com>, Yong Cai <ycai@us.ibm.com>
Subject: [ANNOUNCE] ebizzy 0.2 released
Message-ID: <20070823010626.GC11402@rainbow>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Original-Status: RO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebizzy is designed to generate a workload resembling common web
application server workloads.  It is especially useful for testing
changes to memory management, and whenever a highly threaded
application with a large working set and many vmas is needed.

This is release 0.2 of ebizzy.  It reports a rate of transactions per
second, compiles on Solaris, and scales better.  Thanks especially to
Rodrigo Rubira Branco, Brian Twichell, and Yong Cai for their work on
this release.

Available for download at the fancy new Sourceforge site:

http://sourceforge.net/projects/ebizzy/

ChangeLog below.

-VAL

2008-08-15 Valerie Henson <val@nmt.edu>

        * Release 0.2.

        * Started reporting a rate of transactions per second rather than
                just measuring the time.

        * Solaris compatibility, thanks to Rodrigo Rubira Branco
                <rrbranco@br.ibm.com> for frequent patches and testing.

        * rand() was limiting scalability, use cheap dumb inline "random"
                function to avoid that.  Thanks to Brian Twichell
                <twichell@us.ibm.com> for finding it and Yong Cai
                <ycai@us.ibm.com> for testing.
