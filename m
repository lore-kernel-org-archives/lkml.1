Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZL1LGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZL1LGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZL1LGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:06:52 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40143 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZL1LGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:06:51 -0500
Date: Mon, 28 Dec 2009 06:06:17 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: updated list of "unused" CONFIG variables now online
Message-ID: <alpine.LFD.2.00.0912280602360.13623@localhost>
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


  based on this morning's "git pull", i've updated the list of
tree-wide CONFIG variables that are defined in a Kconfig file
somewhere but don't appear to be tested:

http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables

  a note:  some of those variables are starting to look depressingly
familiar as they've been around for *years*.  in many cases, they
don't hurt as they simply have no value if they're defined but not
tested.

  on the other hand, that list is a good way to identify typoes, as in
this example:

  ===== USB_ETH_EEM
  drivers/usb/gadget/Kconfig:681:config USB_ETH_EEM
  drivers/usb/gadget/ether.c:262:#ifdef USB_ETH_EEM

that's clearly a typo since the #ifdef should be using a "CONFIG_"
prefix -- that's the sort of thing that's flagged at that page.

  it's all broken down by top-level directory and subdirectory so pick
a subdirectory and see if anything looks odd or removable.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
