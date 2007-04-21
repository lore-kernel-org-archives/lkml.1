Return-Path: <linux-kernel-owner+w=401wt.eu-S1031050AbXDUNl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031050AbXDUNl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031058AbXDUNl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:41:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58160 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031055AbXDUNl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:41:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 4/8] propagate error values from clone_mnt
References: <20070420102532.385211890@szeredi.hu>
	<20070420102634.254288123@szeredi.hu>
Date: Sat, 21 Apr 2007 07:40:20 -0600
In-Reply-To: <20070420102634.254288123@szeredi.hu> (Miklos Szeredi's message
	of "Fri, 20 Apr 2007 12:25:36 +0200")
Message-ID: <m1k5w5kfqz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Allow clone_mnt() to return errors other than ENOMEM.  This will be
> used for returning a different error value when the number of user
> mounts goes over the limit.
>
> Fix copy_tree() to return EPERM for unbindable mounts.
>
> Don't propagate further from dup_mnt_ns() as that copy_tree() can only
> fail with -ENOMEM.

At a quick skim this looks ok.

Eric
