Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYDXWsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYDXWsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYDXWsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:48:24 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49185 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYDXWsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:48:23 -0400
Date: Thu, 24 Apr 2008 18:48:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: should NAMESPACES really depend on EMBEDDED?
Message-ID: <alpine.LFD.1.10.0804241845550.18021@localhost.localdomain>
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


  i realize that namespaces represent a feature that could be omitted
for reasons of space, but is it really necessary to make that feature
actually depend on EMBEDDED?  the aesthetics of things depending on
EMBEDDED are already getting a bit grotesque, what with menu entries
magically appearing out of nowhere when you select that feature.  it
would make life easier (and prettier) if that dependency could be
dropped in a few places that aren't critical.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
