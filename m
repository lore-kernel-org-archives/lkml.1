Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452Ab0ATM6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0ATM6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0ATM6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:58:25 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34862 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0ATM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:58:24 -0500
Date: Wed, 20 Jan 2010 07:57:23 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
cc: linux-kernel@vger.kernel.org, hch@infradead.org, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: Obsolete config in kernel build system (XFS_TRACE)
In-Reply-To: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
Message-ID: <alpine.LFD.2.00.1001200756490.19226@localhost>
References: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
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

On Wed, 20 Jan 2010, Christoph Egger wrote:

> Hi all!
>
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
>
> 	Git commit 0b1b213fcf3a8486ada99a2bab84ab8c6f51b264 by
> Christoph Hellwig removed all References to CONFIG_XFS_TRACE, which is
> unreferenced from KConfig side from the linux source code so there's
> only a small bit of it left in KBuild. Mayee remove it as well?
>
> ./fs/xfs/Makefile:95
> +++>
>
> xfs-$(CONFIG_XFS_TRACE)         += xfs_btree_trace.o
>
> <+++

  if the reference is being removed from the Makefile, wouldn't it
also make sense to delete the corresponding source file as well?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
