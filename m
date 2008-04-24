Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYDXQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYDXQ6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYDXQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:58:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45778 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYDXQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:58:28 -0400
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <200804241652.m3OGqRGQ011996@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Thu, 24 Apr 2008 12:52:27 -0400)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <200804241652.m3OGqRGQ011996@agora.fsl.cs.sunysb.edu>
Message-Id: <E1Jp4m0-0004UU-3G@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 18:58:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, unionfs already does some of it now (and some of it can be recoded
> more cleanly), but I'd like to get rid of much of it if I could -- these new
> path_* helpers make me have to maintain vfsmounts even moreso than before.

With the words of Al: "that is hogwash".  Stacks either maintain
vfsmounts or they don't.  There's no middle ground.

Miklos
