Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXKZI5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXKZI5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXKZI4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:56:49 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34130 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbXKZI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:56:46 -0500
Date: Mon, 26 Nov 2007 03:54:48 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can support for "rpm"-based package building just be dropped?
Message-ID: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org


  by that, i mean *requiring* the "rpmbuild" command, and not
accepting "rpm" as a subsititute, as you can read in
scripts/package/Makefile:

# Do we have rpmbuild, otherwise fall back to the older rpm
RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
                   else echo rpm; fi)

  on current systems, "rpm" no longer has build capability and will
fail thusly:

rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
--target: unknown option

  so it would make more sense to just require "rpmbuild" on the
machine, would it not?

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
