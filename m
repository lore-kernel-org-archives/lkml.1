Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZDSTqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZDSTqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 15:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZDSTp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 15:45:59 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49095 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZDSTp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 15:45:59 -0400
Date: Sun, 19 Apr 2009 15:45:02 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
Message-ID: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
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


from arch/x86/Kconfig:
	...
        select HAVE_READQ
        select HAVE_WRITEQ
	...

yet there are no such defined Kconfig vars anywhere.  thoughts?

rday
-


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
