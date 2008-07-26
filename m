Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYGZVyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYGZVyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 17:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbYGZVxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 17:53:54 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55380 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbYGZVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 17:53:53 -0400
Date: Sat, 26 Jul 2008 17:52:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
In-Reply-To: <20080726094718.b617c1e7.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807261750340.3493@localhost.localdomain>
References: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain> <20080726094718.b617c1e7.randy.dunlap@oracle.com>
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

On Sat, 26 Jul 2008, Randy Dunlap wrote:

> On Sat, 26 Jul 2008 09:20:49 -0400 (EDT) Robert P. J. Day wrote:
>
> >
> > Use "menuconfig" to allow all advanced partitions to be deselectable
> > from the top-level FS menu.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
>
> Hi,
>
> I like the idea, but it does have one problem.  Before this patch,
> if someone disabled PARTITION_ADVANCED, the .config would still
> contain CONFIG_MSDOS_PARTITION=y but after this change, that config
> line is missing.  Not good.

ah, quite right.  the obvious solution is to move MSDOS_PARTITION out
of there since it doesn't even *remotely* qualify as an "advanced"
partition -- it's about as basic as it gets.  i'll ponder and
resubmit.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
