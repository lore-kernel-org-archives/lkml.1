Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZDROc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZDROc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZDROct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:32:49 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60114 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZDROcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:32:48 -0400
Date: Sat, 18 Apr 2009 10:31:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: reference to undefined CONFIG_HDPU_FEATURES Kconfig var
Message-ID: <alpine.LFD.2.00.0904181030410.25903@localhost.localdomain>
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


  not sure who to send this to so i'll dump it here:

drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) :=
  hdpu_cpustate.o hdpu_nexus.o
drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/

  that config var doesn't appear to be defined in any Kconfig file.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
