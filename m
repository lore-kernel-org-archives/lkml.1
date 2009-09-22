Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZIVG3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZIVG3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbZIVG3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:29:22 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39591 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZIVG3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:29:21 -0400
Date: Tue, 22 Sep 2009 02:29:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: best practices:  which "uaccess.h" should one include?
Message-ID: <alpine.LFD.2.00.0909220226080.10448@localhost>
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


  philosophically, which is the "correct" uaccess.h header file to
include in kernel code -- <linux/uaccess.h> or <asm/uaccess.h>?  the
first explicitly includes the second so that's a safe choice but,
generally, there's been a tendency to shift toward including the
"linux" header files.  opinion?  there's quite a mixture under the
drivers/ directory.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
