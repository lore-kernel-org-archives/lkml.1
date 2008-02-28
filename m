Return-Path: <linux-kernel-owner+w=401wt.eu-S1762342AbYB1VTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbYB1VTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYB1VTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:19:06 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33039 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYB1VTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:19:05 -0500
Date: Thu, 28 Feb 2008 16:15:31 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
Message-ID: <20080228211531.GE32351@josefsipek.net>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov> <1204144786-3502-4-git-send-email-dpquigl@tycho.nsa.gov> <20080228201004.GC32351@josefsipek.net> <1204231170.24345.100.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204231170.24345.100.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 03:39:30PM -0500, Dave Quigley wrote:
...
> > Alright...so, few things...
> > 
> > 1) why do you need the locked/unlocked versions?
> > 
> > 2) instead of passing a flag to a common function, why not have:
> > 
> > vfs_setxattr_locked(....)
> > {
> > 	// original code minus the lock/unlock calls
> > }
> > 
> > vfs_setxattr(....)
> > {
> > 	mutex_lock(...);
> > 	vfs_setxattr_locked(...);
> > 	mutex_unlock(...);
> > }
> 
> What we do and what you propose aren't logically equivalent. There is a
> permission check inside vfs_setxattr before the mutex lock.

Ah, right. I didn't notice the @@ line...

Josef 'Jeff' Sipek.

-- 
Keyboard not found!
Press F1 to enter Setup
