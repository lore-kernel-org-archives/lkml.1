Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYG1X0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYG1X0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYG1X0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:26:25 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:46031 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYG1X0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:26:24 -0400
Date: Mon, 28 Jul 2008 19:24:47 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Paul Mundt <lethal@linux-sh.org>
cc: magnus.damm@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bad CONFIG variable references from Makefiles
In-Reply-To: <20080728205439.GA27744@linux-sh.org>
Message-ID: <alpine.LFD.1.10.0807281923310.31937@localhost.localdomain>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain> <20080728205439.GA27744@linux-sh.org>
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

On Tue, 29 Jul 2008, Paul Mundt wrote:

> On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> >
> >   a complete list of all references to non-existent CONFIG variables
> > exclusively from Makefiles in the tree.  since the list is so short,
> > i'm not bothering to break it up by subsystem or arch.  enjoy.
> >
> >
> > ===== FB_SH7343VOU =====
> > ./drivers/video/Makefile:obj-$(CONFIG_FB_SH7343VOU)	  += sh7343_voufb.o
>
> Seems to have crept in from a working local tree. It's obviously
> bogus and can simply be killed off.

ok, i can slap together a patch unless someone else gets to it first.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
