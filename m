Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZABPFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZABPFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZABPFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:05:00 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34246 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZABPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:04:59 -0500
X-Greylist: delayed 3333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2009 10:04:59 EST
Date: Fri, 2 Jan 2009 09:08:45 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: worth submitting a detailed EDID structure?
Message-ID: <alpine.LFD.2.00.0901020906310.12465@localhost.localdomain>
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


  just noticed the header file include/video/edid.h, which defines
video EDID info as simply:

  struct edid_info {
        unsigned char dummy[128];
  };

a couple months back, i had to mess with EDID info and defined a
detailed structure to manipulate EDID fields.  is it worth submitting
that as a patch and union'ing that with the above?  not a big deal for
me either way.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
