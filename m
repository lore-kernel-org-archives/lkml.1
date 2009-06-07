Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZFGUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZFGUKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZFGUKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:10:30 -0400
Received: from thunk.org ([69.25.196.29]:48946 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZFGUKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:10:30 -0400
Date: Sun, 7 Jun 2009 16:10:13 -0400
From: Theodore Tso <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Watson <kernel-nospam@dbwatson.ukfsn.org>,
       Jan Kara <jack@suse.cz>, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090607201013.GC23883@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	David Watson <kernel-nospam@dbwatson.ukfsn.org>,
	Jan Kara <jack@suse.cz>, bugzilla-daemon@bugzilla.kernel.org
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.NkB.9j7KKB@chimera> <20090607171418.GA22756@mit.edu> <20090607171739.GI8633@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607171739.GI8633@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 06:17:39PM +0100, Al Viro wrote:
> On Sun, Jun 07, 2009 at 01:14:18PM -0400, Theodore Tso wrote:
> > On Sun, Jun 07, 2009 at 12:06:22PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.28 and 2.6.29.
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
> > > Subject		: ext3/4 with synchronous writes gets wedged by Postfix
> > > Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
> > > Date		: 2009-05-03 19:46 (36 days old)
> > 
> > Al Viro has the fix for this in the for-next branch of his vfs-2.6 git
> > tree, as commit ID 72a43d63: "ext3/4 with synchronous writes gets
> > wedged by Postfix".  I pinged Al previously about pushing this as a
> > regression fix for 2.6.30, but never got a response.  At this point we
> > might as well wait for it to go into the 2.6.31 merge window, and then
> > we can ask for it to go into the 2.6.30.y and 2.6.29.y stable trees.
> 
> It's in mainline now, actually.  But yes, we need it in -stable as well.

Great, thanks; sorry, I didn't realize it had been queued for mainline
submisison, and it wasn't there when I looked last week.  I've closed
the bugzilla entry since it is now in mainline.  Would you like to
send the patch to stable@kernel.org, or shall I?

						- Ted
