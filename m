Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbYEAREm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbYEAREm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYEAREd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:04:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53720 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYEAREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:04:32 -0400
To: dave@linux.vnet.ibm.com
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <1209660018.16729.3.camel@nimitz.home.sr71.net> (message from
	Dave Hansen on Thu, 01 May 2008 09:40:18 -0700)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu>
	 <1209620457.4461.59.camel@nimitz.home.sr71.net>
	 <E1JrTpy-0004mH-Gg@pomaz-ex.szeredi.hu> <1209660018.16729.3.camel@nimitz.home.sr71.net>
Message-Id: <E1JrcCR-0005tn-B9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 May 2008 19:04:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a way we could pass around a vfs-internal object to these
> things?  Maybe something that is like an opaque token only known to the
> vfs?

vfsmount itself should be an opaque token to anything but the
namespace code.  So the definition could just be moved into say
fs/vfsmount.h, and be done with that.

Probably not a trivial cleanup to do (s_op->show_options() is a major
offender), but I don't see any major roadblocks.

Miklos
