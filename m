Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869Ab0ACM00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0ACM00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 07:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819Ab0ACM0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 07:26:24 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:48772 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0ACM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 07:26:23 -0500
Date: Sun, 3 Jan 2010 07:25:45 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: waite@skycomputers.com
Subject: what's the situation with CONFIG_HDPU_FEATURES?
Message-ID: <alpine.LFD.2.00.1001030721060.13567@localhost>
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


$ grep -r HDPU_FEATURES *
drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) := hdpu_cpustate.o hdpu_nexus.o
$

  so it's not selectable and nothing's building it.  thoughts?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
