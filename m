Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbZFKRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbZFKRAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZFKRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:00:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:36776 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbZFKRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:00:13 -0400
Date: Thu, 11 Jun 2009 13:00:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many
 processes
In-Reply-To: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Justin Piszcz wrote:

> Hello,
>
> I have a daily cron that backs up my root filesystem using xfsdump, it has 
> remain unchanged for at least 7-10 kernel versions.  When I migrated to 
> 2.6.30, when the xfsdump ran at its scheduled time, nearly all of my 
> processes were killed due to an OOM situation, I can reproduce the situation.
>
> Kernel: 2.6.30
> Dist: Debian Testing
> xfsdump: 2.2.48-1

Kernel 2.6.29.4 does not exhibit this problem:

xfsdump: estimated dump size: 8694781376 bytes
xfsdump: creating dump session media file 0 (media 0, file 0)
xfsdump: dumping ino map
xfsdump: dumping directories
xfsdump: dumping non-directory files
xfsdump: ending media file
xfsdump: media file size 8294709848 bytes
xfsdump: dump size (non-dir files) : 8208863560 bytes
xfsdump: dump complete: 102 seconds elapsed
xfsdump: Dump Status: SUCCESS

XFS(?) bug in 2.6.30.

Justin.

