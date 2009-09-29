Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZI2XL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZI2XL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 19:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZI2XLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 19:11:55 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:52525 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZI2XLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 19:11:55 -0400
Date: Tue, 29 Sep 2009 19:11:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any interest in unreferenced header files throughout the tree?
Message-ID: <alpine.LFD.2.00.0909291906060.9535@localhost>
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


  with a minor tweak to one of my scripts, i can now identify all
header files throughout the source tree that no one seems to be using,
and i can generate that output broken down as usual by logical
subdirectories.

  as a simple example, under fs/, there appears to be a single unused
header file:

  fs/xfs/xfs_refcache.h

if there's interest, i can generate output for the entire tree and
post it at the normal wiki location.

rday

p.s.  there's a *lot* of them under arch/.

--


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
