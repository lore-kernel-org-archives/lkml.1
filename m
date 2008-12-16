Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYLPBrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYLPBrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYLPBq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:46:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39160 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbYLPBqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:46:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 1/3] filesystem notification: create fs/notify to contain all fs notification
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <1229391456.23523.10.camel@localhost.localdomain>
References: <20081216095546.06C7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1229391456.23523.10.camel@localhost.localdomain>
Message-Id: <20081216104219.06D0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 10:46:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1) this mail only contain Kconfig and Makefile changing patch.
> >    iow, this patch doesn't contain file moving information.
> >    iow, patch statics and actual patch are different.
> > 2) your latter patch doesn't depend on this patch.
> >    this patch doesn't have justification.
> >    I recommend to separate this patch.
> 
> It is there, it is just in the git -M rename diff output rather than
> "normal" diff.  See the sections like:
> 
> diff --git a/fs/dnotify.c b/fs/notify/dnotify/dnotify.c
> similarity index 100%
> rename from fs/dnotify.c
> rename to fs/notify/dnotify/dnotify.c
> 
> This type of patch can be applied directly to your git tree and makes
> review trivial.....
> 
> If people who will put this into a subsystem would prefer the long diff
> I'll gladly resend.

Oh sorry ;)
To be honest, almost linux-mm develper are using quilt and I don't use
git almost case.


> I'll agree it isn't required but the other 2 aren't going to apply
> without it, and it does clean up fs.  I'd much rather get this early
> than in the middle somewhere since others are also looking at changing
> this subsystem at the same time....     It can be dropped it others
> agree....

I don't objection this cleanup. but the patch series should be made by
logical group.
I don't like to contain independent cleanup patch ;-)


