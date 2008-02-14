Return-Path: <linux-kernel-owner+w=401wt.eu-S1759692AbYBNQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692AbYBNQmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYBNQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:42:03 -0500
Received: from mail.tmr.com ([64.65.253.246]:39632 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbYBNQmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:42:01 -0500
Message-ID: <47B46FA5.7070002@tmr.com>
Date: Thu, 14 Feb 2008 11:43:17 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: rokr@hermes-softlab.com
CC: linux-kernel@vger.kernel.org
Subject: Re: reading user. extended attributes from symlinks in 2.6 kernels
References: <20080211173809.4a2db13f@hermes-softlab.com>
In-Reply-To: <20080211173809.4a2db13f@hermes-softlab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rok Ruzic wrote:
> Hello,
> 
> I have an XFS filesystem containing files and symlinks with application-specific EAs in the user namespace. The files, symlinks and their EAs were created while running a 2.4 kernel. 
> 
> In 2.6 kernels access to user EAs was prevented for symlinks. My
problem is that i have to upgrade the kernel from 2.4 to 2.6 series and
i have to have access to all the EAs after upgrade. Is there a way to
read user EAs off of symlinks on an XFS filesystem on a 2.6 kernel
either from userspace or from a filter driver sitting between VFS and
XFS filesystem code?
> 
> I would appreciate it very much if somebody could point me towards a solution.
> 
If you want to do it at user code level, you could note the symlink, 
follow it to the "real" name, and read the EA there. I don't see any 
easy way to force the kernel to follow the symlink.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
