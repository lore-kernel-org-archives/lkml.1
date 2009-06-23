Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbZFWOPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbZFWOPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZFWOO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:14:58 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:43746 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbZFWOO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:14:58 -0400
Date: Tue, 23 Jun 2009 10:12:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what is "hdpuftrs"?
Message-ID: <alpine.LFD.2.00.0906231010520.23515@localhost>
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


  recent source code scan reveals reference to non-existent CONFIG
variable:

===== HDPU_FEATURES =====
./drivers/misc/Makefile:obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
./drivers/misc/hdpuftrs/Makefile:obj-$(CONFIG_HDPU_FEATURES) :=
hdpu_cpustate.o hdpu_nexus.o

 there's nothing listed in MAINTAINERS for whatever that is.

rday
--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
