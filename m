Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbYDYW0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbYDYW0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbYDYWX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:23:27 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:42649 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761580AbYDYWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:23:26 -0400
Date: Fri, 25 Apr 2008 18:23:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can the 4KSTACKS selection be moved out from under kernel
 debugging?
Message-ID: <alpine.LFD.1.10.0804251821050.29563@localhost.localdomain>
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


  in the first place, it's already partially moved out anyway, since
x86 and SH define it as a debugging feature, while m68knommu doesn't.
more importantly, it simply isn't a debug feature and there's already
more than enough under the kernel debugging menu.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
