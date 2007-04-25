Return-Path: <linux-kernel-owner+w=401wt.eu-S1031109AbXDYTfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031109AbXDYTfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031114AbXDYTfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:35:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031106AbXDYTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:35:13 -0400
Date: Wed, 25 Apr 2007 12:33:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch] unprivileged mounts update
Message-Id: <20070425123346.6a8953c2.akpm@linux-foundation.org>
In-Reply-To: <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu>
	<E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 17:18:12 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > - refine adding "nosuid" and "nodev" flags for unprivileged mounts:
> >     o add "nosuid", only if mounter doesn't have CAP_SETUID capability
> >     o add "nodev", only if mounter doesn't have CAP_MKNOD capability
> > 
> > - allow unprivileged forced unmount, but only for FS_SAFE filesystems
> > 
> > - allow mounting over special files, but not symlinks
> > 
> > - for mounting and umounting check "fsuid" instead of "ruid"
> 
> Andrew, please skip this patch, for now.

I'll be dropping all the unprivileged-mounts stuff - it looks like it
was a bit early, and that a new patch series against 2.6.27-rc1 or thereabouts
would be best.
