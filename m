Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZKTJbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZKTJbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZKTJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:31:48 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48184 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZKTJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:31:47 -0500
To: Pavel Machek <pavel@ucw.cz>
CC: jlayton@redhat.com, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20091119213935.GA11212@elf.ucw.cz> (message from Pavel Machek on
	Thu, 19 Nov 2009 22:39:35 +0100)
Subject: Re: [PATCH] procfs: make /proc style symlinks behave like "normal"
 symlinks
References: <1258638251-20034-1-git-send-email-jlayton@redhat.com>
 <m14ooq5tq3.fsf@fess.ebiederm.org>
 <20091119132833.30bc93a4@barsoom.rdu.redhat.com>
 <m1skca2vi3.fsf@fess.ebiederm.org>
 <20091119143555.7851953f@barsoom.rdu.redhat.com> <20091119213935.GA11212@elf.ucw.cz>
Message-Id: <E1NBPq8-0001D7-F9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 20 Nov 2009 10:31:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Pavel Machek wrote:
> > Adding the missing revalidations is fine, but I don't believe that
> > helps to fix Pavel's issue. I'll go back and take a more careful look
> > at the suggestion that Miklos made and see whether it makes sense to
> > implement a new FS_* flag for this, and see what it'll take to fix
> > Pavel's issue.

What is this "Pavel's issue"?

> One posibility would be to make open(/proc/XX/fd/XX) behave like
> dup(). That should solve the NFS problems, too, no?

You mean, reuse the old "struct file" for the new open?  Or what?

Thanks,
Miklos
