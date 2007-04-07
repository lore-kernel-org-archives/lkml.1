Return-Path: <linux-kernel-owner+w=401wt.eu-S966344AbXDGU6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966344AbXDGU6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 16:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966345AbXDGU6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 16:58:24 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:47176 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966344AbXDGU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 16:58:23 -0400
Date: Sat, 07 Apr 2007 16:58:11 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.21-rc6
In-reply-to: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <200704071658.11825.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007, Linus Torvalds wrote:
>Ok,
> I don't think there really is anything very interesting here, but we're
>hopefully whittling down the list of regressions, and fixing various
>random other small issues while at it.
>
>Some smallish MIPS updates, networking (and network driver) fixes,
> removal of a long obsolete framebuffer driver, etc etc. The shortlog
> really tells the story.
>
>We should be getting close to a 2.6.21 release, so please update any
>regression reports you've done,
>
>		Linus

[...]
>
>
>Andrew Morton (4):
>      proc: fix linkage with CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n
>      revert "retries in ext3_prepare_write() violate ordering
> requirements" revert "retries in ext4_prepare_write() violate ordering
> requirements" remove protection of LANANA-reserved majors
>
FWIW, this last reversion didn't do it quite right, the device-mapper was 
at 253 prior to this patches parent patch, and now its at 252, which is 
still a 'dump it all' change for both tar & dump.  Until things settle, 
I'm going to test and probably use the instructions that Dave Dillow just 
sent me, which should put it at 238 regardless.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Looks clean and obviously correct to me, but then _everything_ I write
 always looks obviously correct yo me."

	- Linus
