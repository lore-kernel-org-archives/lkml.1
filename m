Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYCWGcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYCWGcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 02:32:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYCWGbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 02:31:55 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38605 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYCWGby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 02:31:54 -0400
Date: Sun, 23 Mar 2008 02:31:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why so many unexported headers checking __KERNEL__?
Message-ID: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


  as an unintended side effect of checking for proper exporting to
user space and unifdef'ing, i noticed that there are literally
hundreds of kernel header files that check the value of __KERNEL__ in
some way, but are never exported to user space.  what's the point of
that?  thanks.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
