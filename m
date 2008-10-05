Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYJEFjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYJEFjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 01:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYJEFi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 01:38:56 -0400
Received: from kroah.org ([198.145.64.141]:41202 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751356AbYJEFi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 01:38:56 -0400
Date: Sat, 4 Oct 2008 22:32:36 -0700
From: Greg KH <greg@kroah.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081005053236.GA9472@kroah.com>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003101331.GH28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 11:13:31AM +0100, Al Viro wrote:
> On Tue, Sep 23, 2008 at 11:23:57AM -0700, Eric W. Biederman wrote:
> > Benjamin Thery <benjamin.thery@bull.net> writes:
> > >
> > > Oh.
> > > It's a pity Al couldn't re-review them before. We've already lost a lot
> > > of time with this patchset and it's blocking easier testing of network
> > > namespaces (right now, with a mainline kernel, we have to disable sysfs
> > > to build network namespaces).
> > 
> > I am confident that we have a good base with these patches and the rest of
> > the work can be done incrementally on top of them if any issues turn up.
> > 
> > Al recent rework of sysctl has a very similar structure.
> 
> No, it does not.  My apologies for delay, but here are more printable parts
> of review.

<snip>

Al, thanks a lot for the review, I really appreciate it.

Eric, I've removed the following patches from my tree so you can rework
them, if you want to.

	driver-core/sysfs-support-for-preventing-unmounts.patch
	driver-core/sysfs-sysfs_get_dentry-add-a-sb-parameter.patch
	driver-core/sysfs-implement-__sysfs_get_dentry.patch
	driver-core/sysfs-rename-support-multiple-superblocks.patch
	driver-core/sysfs-introduce-sysfs_sd_setattr-and-fix-sysfs_chmod.patch
	driver-core/sysfs-sysfs_chmod_file-handle-multiple-superblocks.patch
	driver-core/sysfs-implement-sysfs-tagged-directory-support.patch
	driver-core/sysfs-merge-sysfs_rename_dir-and-sysfs_move_dir.patch
	driver-core/sysfs-implement-sysfs_delete_link-and-sysfs_rename_link.patch
	driver-core/driver-core-implement-tagged-directory-support-for-device-classes.patch
	driver-core/sysfs-remove-sysfs_create_link_nowarn.patch
	driver-core/sysfs-revert-netns-fix-device-renaming-for-sysfs.patch
	driver-core/netns-enable-tagging-for-net_class-directories-in-sysfs.patch
	driver-core/sysfs-user-namespaces-fix-bug-with-clone-with-fairsched.patch

thanks,

greg k-h
