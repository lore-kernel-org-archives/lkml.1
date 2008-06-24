Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYFXKty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYFXKty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYFXKtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:49:46 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:59257 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYFXKtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:49:45 -0400
Date: Tue, 24 Jun 2008 06:49:38 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any reason for the continued hard-coding of "BUILD_CRAMDISK"?
Message-ID: <alpine.LFD.1.10.0806240648030.27913@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


  just curious as to whether there is still some value for the
explicit definition of the BUILD_CRAMDISK macro in
init/do_mounts_rd.c.  that macro is unreferenced anywhere else in the
tree, so it seems pointless to define and test a macro within the same
source file.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
