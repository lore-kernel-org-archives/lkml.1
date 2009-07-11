Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbZGKSUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbZGKSUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZGKSUC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:20:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbZGKSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:20:01 -0400
Date: Sat, 11 Jul 2009 11:19:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Subject: RE: commit 097041e576ee3a50d92dd643ee8ca65bf6a62e21 (fuse: Fix build
 error)
In-Reply-To: <1247321214.5615.6.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.2.01.0907111119170.3552@localhost.localdomain>
References: <1247321214.5615.6.camel@heimdal.trondhjem.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Jul 2009, Trond Myklebust wrote:
> 
> Please revert this commit. Instead of fixing the compile problem, it
> adds a new dependency on CONFIG_BLOCK to both NFS and FUSE. Neither one
> of them has such a dependency today, nor is there a reason to introduce
> one. 
> 
> The correct fix should rather be to move the definitions of BLK_RW_SYNC
> and BLK_RW_ASYNC into backing-dev.h as per the patch below.

Right you are. Thanks,

		Linus
