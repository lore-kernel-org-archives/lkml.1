Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXDUIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXDUIPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 04:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXDUIPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 04:15:36 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:37488 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXDUIPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 04:15:35 -0400
To: akpm@linux-foundation.org
CC: ericvh@gmail.com, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
In-reply-to: <20070421005513.e230aa88.akpm@linux-foundation.org> (message from
	Andrew Morton on Sat, 21 Apr 2007 00:55:13 -0700)
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu> <20070421005513.e230aa88.akpm@linux-foundation.org>
Message-Id: <E1HfAig-0002Ll-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 21 Apr 2007 10:13:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 20 Apr 2007 12:25:39 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Define a new fs flag FS_SAFE, which denotes, that unprivileged
> > mounting of this filesystem may not constitute a security problem.
> > 
> > Since most filesystems haven't been designed with unprivileged
> > mounting in mind, a thorough audit is needed before setting this flag.
> 
> Practically speaking, is there any realistic likelihood that any filesystem
> apart from FUSE will ever use this?

V9FS people did express an interest in this.  Yeah, I should've CC-ed
them, but forgot.  Sorry.

Miklos
