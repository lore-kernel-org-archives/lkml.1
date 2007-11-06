Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbXKFD5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbXKFD5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXKFD5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:57:01 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:39669 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbXKFD5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:57:00 -0500
Date: Mon, 5 Nov 2007 22:55:25 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: the value in exporting unused header files?
Message-ID: <Pine.LNX.4.64.0711052252280.31528@localhost.localdomain>
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


  as part of the output of yet another cleanup script i have, we
notice that:

$ grep -r if_wanpipe *
Documentation/networking/wan-router.txt:        if_wanpipe.h    WANPIPE Socket definitions
include/linux/Kbuild:unifdef-y += if_wanpipe.h
include/linux/if_wanpipe.h:* if_wanpipe.h       Header file for the Sangoma AF_WANPIPE Socket
$

  in other words, a header file that is not included by any other file
in the tree is still being exported to user space.  is that normal?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
