Return-Path: <linux-kernel-owner+w=401wt.eu-S1030455AbXDUH5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbXDUH5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXDUH5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:57:10 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030351AbXDUH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:56:57 -0400
Date: Sat, 21 Apr 2007 00:55:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 8/8] allow unprivileged fuse mounts
Message-Id: <20070421005516.18e0c797.akpm@linux-foundation.org>
In-Reply-To: <20070420102656.364689151@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
	<20070420102656.364689151@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 12:25:40 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> 
> FUSE was designed from the beginning to be safe for unprivileged
> users.  This has also been verified in practice over many years.

How does FUSE do this?

There are obvious cases like crafting a filesystem which has setuid executables
or world-writeable device nodes or whatever.  I'm sure there are lots of other
cases.

Where is FUSE's implementation of all this protection described?
