Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYBMLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYBMLqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYBMLqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:46:08 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39493 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbYBMLqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:46:06 -0500
Date: Wed, 13 Feb 2008 06:46:01 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad CONFIG variable references in *Makefiles*
Message-ID: <alpine.LFD.1.00.0802130643100.27759@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


  unlike the previous list, here's a (much shorter) list of references
to CONFIG_ variables that occur in Makefiles that don't appear to be
defined anywhere in the tree.

  because this is a much shorter list, i don't break it down by
subdirectory, it covers the entire tree:

http://www.crashcourse.ca/wiki/index.php/Badref_make_CONFIG_variables

  for example:

...
===== MSPETH =====
./arch/mips/pmc-sierra/msp71xx/Makefile:obj-$(CONFIG_MSPETH) += msp_eth.o
...

  that makefile conditionally compiles based on the value of
CONFIG_MSPETH, despite the fact that CONFIG_MSPETH is not defined
anywhere.  you get the idea.  there are only a couple dozen of these.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
