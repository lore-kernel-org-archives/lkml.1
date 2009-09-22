Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZIVR2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZIVR2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZIVR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZIVR2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:28:52 -0400
Subject: Re: [PATCH] vfs: new FROM_ACCESS flag
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <20090922135612.GA17769@infradead.org>
References: <20090921013048.2763.1494.stgit@paris.rdu.redhat.com>
	 <20090922135612.GA17769@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Sep 2009 13:28:46 -0400
Message-Id: <1253640526.2747.7.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 09:56 -0400, Christoph Hellwig wrote:
> On Sun, Sep 20, 2009 at 09:30:48PM -0400, Eric Paris wrote:
> > This new acc_mode flag is just to tell the security system this inode
> > permission check is from the access system call.  The security system can
> > use this information as it finds appropriete.  In particular SELinux plans to
> > use this flag to alter what we choose to audit and what we do not choose to
> > audit.
> 
> I think you're better off splitting the existing MAY_ACCESS flag and
> only using MAY_ACCESS for calles from access() insteaf of introducing
> a FROM_ACCESS flag and causing lots of naming confusion.

What would you think of a new, MUST_REVALIDATE_PERMS which will do what
MAY_ACCESS does today.  MAY_ACCESS would be just for access(2) and would
be the flag that I use for SELinux?

-Eric

