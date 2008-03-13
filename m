Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYCMWyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYCMWyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYCMWyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:54:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbYCMWyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:54:23 -0400
Date: Thu, 13 Mar 2008 15:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6] vfs: mountinfo update
Message-Id: <20080313155315.6eb9942e.akpm@linux-foundation.org>
In-Reply-To: <20080313212641.989467982@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 22:26:41 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Hi Andrew,
> 
> Here are several updates to the /proc/<pid>/mountinfo patch by Ram and
> me.  These hopefully address all comments by you, Al and others.
> 

diffstat for all seven patches is:

 Documentation/filesystems/proc.txt |   35 +++++
 fs/dcache.c                        |  101 +++++++++++---
 fs/namespace.c                     |  182 ++++++++++++++++++++++-----
 fs/pnode.c                         |  131 ++++++++++++++++++-
 fs/pnode.h                         |   15 +-
 fs/proc/base.c                     |  121 +++++++++--------
 fs/seq_file.c                      |   92 +++++++++++--
 include/linux/dcache.h             |    5 
 include/linux/mnt_namespace.h      |   12 +
 include/linux/mount.h              |    2 
 include/linux/seq_file.h           |    7 +
 11 files changed, 559 insertions(+), 144 deletions(-)

that's a mountain of tricksy new core-kernel code just for some /proc file.

Is this all really justifiable?
