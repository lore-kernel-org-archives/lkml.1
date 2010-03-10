Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0CJKkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:40:15 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:47573 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0CJKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:40:14 -0500
Date: Wed, 10 Mar 2010 05:38:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: most popular kernel cleanup scripts now posted
Message-ID: <alpine.LFD.2.00.1003100535120.4271@localhost>
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


  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

* unused CONFIG variables:  variables defined in a Kconfig* file
somewhere that don't appear to be subsequently used/tested

* badref CONFIG variables:  variables used/tested in kernel source
that don't appear to be defined in any Kconfig file

* badref CONFIG variables in Makefile:  special case of above, for
variables strictly in Makefiles

* badref "select" directives:  Kconfig select directives to
non-existent CONFIG variables

* badref linux header files:  inclusions of header files of the form
<linux/whatever.h> where said file does not appear to exist.

  please don't make fun of my code.  it's very sensitive about that.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
