Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZF1L6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZF1L6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZF1L6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:58:24 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58641 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF1L6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:58:23 -0400
Date: Sun, 28 Jun 2009 07:56:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: does CONFIG_MODULE_SRCVERSION_ALL depend on MODULE_VERSION?
Message-ID: <alpine.LFD.2.00.0906280752060.7674@localhost>
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


  from the help text for CONFIG_MODULE_SRCVERSION_ALL:

"Modules which contain a MODULE_VERSION get an extra "srcversion"
field inserted into their modinfo section, which contains a
sum of the source files which made it.  This helps maintainers
see exactly which source was used to build a module (since
others sometimes change the module source without updating
the version).  With this option, such a "srcversion" field
will be created for all modules.  If unsure, say N."

  that first sentence suggests that calculating a module's
"srcversion" value depends on whether you've provided a MODULE_VERSION
value, but that doesn't seem to be the case based on a test i just
made.  and it seems to disagree with the later sentence that this
CONFIG option will generate a srcversion value for "all" modules
regardless.

  clarification?  it seems that first sentence is misleading, unless
i'm misreading it.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
