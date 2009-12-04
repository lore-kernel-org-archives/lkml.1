Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZLDPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZLDPqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 10:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZLDPqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 10:46:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZLDPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 10:46:17 -0500
Subject: Re: [PATCH 1/5] fsnotify/vfsmount: add fsnotify fields to struct
 vfsmount
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, agruen@suse.de
In-Reply-To: <20091204153925.GA17062@infradead.org>
References: <20091203055315.21918.83562.stgit@paris.rdu.redhat.com>
	 <20091204153925.GA17062@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 10:46:14 -0500
Message-Id: <1259941574.2722.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 10:39 -0500, Christoph Hellwig wrote:
> On Thu, Dec 03, 2009 at 12:53:15AM -0500, Eric Paris wrote:
> > From: Andreas Gruenbacher <agruen@suse.de>
> > 
> > This patch adds the list and mask fields needed to support vfsmount marks.
> > These are the same fields fsnotify needs on an inode.  They are not used,
> > just declared and we note where the cleanup hook should be (the function is
> > not yet defined)
> 
> What's the rationale for adding them?

As opposed to 'global' listeners I've discussed before, Andreas ask me
to write per mount listeners.  It's somewhere in between global and per
inode.  With this series One can now register to listen on a struct
vfsmount instead.  I'll update this patch description to better explain
the point.

-Eric


