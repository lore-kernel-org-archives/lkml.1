Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXDLFUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXDLFUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXDLFUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:20:20 -0400
Received: from server2.meudns3.com ([74.52.31.50]:26391 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663AbXDLFUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:20:20 -0400
From: Pedro <linux_user@izecksohn.com>
To: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 02:19:02 -0300
User-Agent: KMail/1.9.5
References: <200704110223.31291.linux_user@izecksohn.com> <200704111927.00609.linux_user@izecksohn.com> <20070411233921.7a5c3cff@the-village.bc.nu>
In-Reply-To: <20070411233921.7a5c3cff@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704120219.03171.linux_user@izecksohn.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server2.meudns3.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - izecksohn.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 April 2007 19:39, Alan Cox wrote:
> >   2) How should an application be written to not be killed by OOM?
>
> OOM isn't an application matter. The kernel has to choose between
> allowing overcommit on the basis it might run out of memory and have to
> kill stuff, or that it won't in which case an applicatio which correctly
> handles malloc() and similar failures will not be killed (unless it is
> out of space on a stack grow which is a C language flaw as you can't
> catch that event in C)
>
> It's configured by /proc/sys/vm/overcommit_memory
>
> 0 - try and spot obviously dumb allocations
> 1 - anything goes
> 2 - strictly control resource commit

  I deduce that a fail-safe application must scanf overcommit_memory, warn 
the user and waitpid.
