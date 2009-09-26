Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIZMQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIZMQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZIZMQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:16:10 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:48509 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZIZMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:16:09 -0400
Date: Sat, 26 Sep 2009 08:16:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: how best to report results of my kernel tree scanning scripts?
Message-ID: <alpine.LFD.2.00.0909260811470.19017@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since the merge window appears to be ready to close fairly soon(?),
i'm prepping to run my scanning scripts once again to identify (among
other things):

  * unused Kconfig CONFIG variables
  * references to CONFIG_ variables that don't even exist (both in
    source files and Makefiles)
  * references to non-existent header files

and bunches of other things.  i'm open as to the best way to post the
results, since different people have different opinions.

  and, no, i can't just submit patches since, in many cases, i have no
idea what the fix should be (if any) -- that's the kind of decision
best left to the respective subsystem maintainers.

  thoughts?  this is where i put the old output:

http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
