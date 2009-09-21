Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZIUBwC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZIUBwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 21:52:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZIUBwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 21:52:01 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:42172 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbZIUBwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 21:52:00 -0400
Subject: Re: [PATCH] VFS: document what MAY_ACCESS means
From: Nicholas Miell <nmiell@comcast.net>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org
In-Reply-To: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Sun, 20 Sep 2009 18:52:01 -0700
Message-Id: <1253497921.30237.1.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this is a documentation patch, here are some nits.

> +/*
> + * The vfs MAY_ACCESS flag really means that we might not use the object
> + * immediately (consider chdir which might not actually use the new dir).
> + * Thus permissions must be checked mmediately rather than relying on later
                                       ^ immediately
> + * checks during the actual user of the object in question.  This is an
                               ^ use
> + * internal flag and should not come from userspace.
> + */
>  #define MAY_ACCESS 16
>  #define MAY_OPEN 32

-- 
Nicholas Miell <nmiell@comcast.net>

