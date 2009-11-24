Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbZKXM7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbZKXM7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZKXM7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:59:22 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36642 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbZKXM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:59:22 -0500
To: Pavel Machek <pavel@ucw.cz>
CC: miklos@szeredi.hu, jlayton@redhat.com, jamie@shareable.org,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
In-reply-to: <20091124120906.GA1700@ucw.cz> (message from Pavel Machek on Tue,
	24 Nov 2009 13:09:06 +0100)
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
	and file bind mounts (try #5)
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <m1ljhwbyr3.fsf@fess.ebiederm.org> <20091123193426.55f1530a@tlielax.poochiereds.net> <20091124012027.GA14645@shareable.org> <20091124062621.744beddb@tlielax.poochiereds.net> <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu> <20091124120906.GA1700@ucw.cz>
Message-Id: <E1NCuz4-00010e-Ch@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Nov 2009 13:59:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Pavel Machek wrote:
> I believe that current semantics is ugly enough that 'documenting' it
> is not enough... and people want to port from other systems, too, not
> expecting nasty surprises like this...

This hasn't been a problem for the last 12 years, and still we don't
see script kiddies exploiting this hole and sysadmins hurrying to
secure their system, even though it has been public for quite a while.

Why?

The reason might be, that there *is no* violation of security.

See this: the surprise isn't that an inode can be reached from
multiple paths, that has been possible with hard links for as long as
unix lived.  The suprise is that the inode can be reached through
proc.  So this "hole" that has been opened about 12 years ago in linux
is quite well known.  Only this particular aspect of it isn't well
known, but that doesn't mean it's not right, does it?

Thanks,
Miklos
