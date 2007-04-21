Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXDUIZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXDUIZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXDUIZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:25:09 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:39481 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030316AbXDUIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:24:56 -0400
To: akpm@linux-foundation.org
CC: ericvh@gmail.com, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <E1HfAig-0002Ll-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Sat, 21 Apr 2007 10:13:22 +0200)
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu> <20070421005513.e230aa88.akpm@linux-foundation.org> <E1HfAig-0002Ll-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HfAsR-0002Nw-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 10:23:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > > Define a new fs flag FS_SAFE, which denotes, that unprivileged
> > > mounting of this filesystem may not constitute a security problem.
> > > 
> > > Since most filesystems haven't been designed with unprivileged
> > > mounting in mind, a thorough audit is needed before setting this flag.
> > 
> > Practically speaking, is there any realistic likelihood that any filesystem
> > apart from FUSE will ever use this?
> 
> V9FS people did express an interest in this.  Yeah, I should've CC-ed
> them, but forgot.  Sorry.

And CIFS maybe.  They also have an unprivileged mounting suid hack.
But I'm not very optimistic about CIFS, seeing some of the code,
that's in there.

Miklos
