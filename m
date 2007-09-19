Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbXISV1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbXISV1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXISVZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069AbXISVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:23 -0400
Date: Wed, 19 Sep 2007 14:24:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 00/24] Read-only bind mounts
Message-Id: <20070919142437.7490b219.akpm@linux-foundation.org>
In-Reply-To: <20070919174418.GA22982@infradead.org>
References: <20070917182718.70494C9B@kernel>
	<20070919174418.GA22982@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 18:44:18 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Sep 17, 2007 at 11:27:18AM -0700, Dave Hansen wrote:
> > If we can't pull the entire series into -mm, can we just put the
> > first three patches for now?  They can stand on their own.
> 
> Yes, they're kinda a series of their own.  But I still think we really
> want this in -mm.  As we've seen on the kernel summit there's a pretty
> desparate need for it.  And there's not many changes in this area in
> -mm, maybe the unprivilegued mounts.  I'd personally prioritize the
> r/o bindmounts over them as they're more needed and we need more reviewing
> of the unprivilegued mounts (I'll try to come back to that soon).

What's the situation on unprivileged mounts?  iirc, it's all a bit stuck.

If unpriv-mounts code isn't going to go into mainline ahead of r/o bind
mounts then it'd make a big mess to prepare the r/o bind mount patches on
top of unprivileged mounts.

It sounds like a better approach would be for me to merge the r/o bind
mounts code and to drop (or maybe rework) the unprivileged mounts patches

