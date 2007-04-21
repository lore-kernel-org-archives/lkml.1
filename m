Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXDUISb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXDUISb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXDUISb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:18:31 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:59086 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030190AbXDUISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:18:30 -0400
To: akpm@linux-foundation.org
CC: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <20070421005516.18e0c797.akpm@linux-foundation.org> (message from
	Andrew Morton on Sat, 21 Apr 2007 00:55:16 -0700)
Subject: Re: [patch 8/8] allow unprivileged fuse mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102656.364689151@szeredi.hu> <20070421005516.18e0c797.akpm@linux-foundation.org>
Message-Id: <E1HfAlG-0002MD-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 10:16:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> > 
> > FUSE was designed from the beginning to be safe for unprivileged
> > users.  This has also been verified in practice over many years.
> 
> How does FUSE do this?
> 
> There are obvious cases like crafting a filesystem which has setuid executables
> or world-writeable device nodes or whatever.  I'm sure there are lots of other
> cases.
> 
> Where is FUSE's implementation of all this protection described?

Most of it is in Documentation/filesystems/fuse.txt, some of it is
code comments.

Miklos
