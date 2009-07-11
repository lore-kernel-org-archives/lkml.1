Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZGKRka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZGKRka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 13:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZGKRkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 13:40:20 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:43637 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZGKRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 13:40:20 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A58CE90.2070301@lwfinger.net>
Date: Sat, 11 Jul 2009 12:40:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: commit 097041e576ee3a50d92dd643ee8ca65bf6a62e21 (fuse: Fix build
 error)
References: <1247321214.5615.6.camel@heimdal.trondhjem.org>
In-Reply-To: <1247321214.5615.6.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> Hi Linus
> 
> Please revert this commit. Instead of fixing the compile problem, it
> adds a new dependency on CONFIG_BLOCK to both NFS and FUSE. Neither one
> of them has such a dependency today, nor is there a reason to introduce
> one. 
> 
> The correct fix should rather be to move the definitions of BLK_RW_SYNC
> and BLK_RW_ASYNC into backing-dev.h as per the patch below.
> 
> Cheers
>   Trond

I understand that my "fix" was wrong. I'm sure that Linus is on top of
this, but your patch must be added before reverting 097071e5,
otherwise a new build failure is introduced that might be encountered
when bisecting. Why not undo my changes and add yours in a single patch?

Larry

