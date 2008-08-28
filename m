Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYH1WVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYH1WVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbYH1WVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:21:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYH1WVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:21:08 -0400
Date: Thu, 28 Aug 2008 15:15:25 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
	Userspace
Message-ID: <20080828221525.GA2855@kroah.com>
References: <1219947544-666-1-git-send-email-tj@kernel.org> <1219947544-666-6-git-send-email-tj@kernel.org> <20080828130740.344f7213.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828130740.344f7213.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:07:40PM -0700, Andrew Morton wrote:
> On Fri, 29 Aug 2008 03:19:04 +0900
> Tejun Heo <tj@kernel.org> wrote:
> > +#define fc_to_cc(_fc)		container_of((_fc), struct cuse_conn, fc)
> > +#define cdev_to_cc(_cdev)	container_of((_cdev), struct cuse_conn, cdev)
> > +#define cuse_conn_get(cc)	({mntget((cc)->mnt); cc;})
> > +#define cuse_conn_put(cc)	mntput((cc)->mnt)
> 
> I believe all the above could be implemented in C.

"traditionally" container_of() is used in #define, not a function call
as it is just pointer math that can be done at compile time.

thanks,

greg k-h
