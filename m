Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZFGRRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZFGRRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZFGRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:17:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54432 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZFGRRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:17:39 -0400
Date: Sun, 7 Jun 2009 18:17:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Watson <kernel-nospam@dbwatson.ukfsn.org>,
       Jan Kara <jack@suse.cz>, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug #13232] ext3/4 with synchronous writes gets wedged by
	Postfix
Message-ID: <20090607171739.GI8633@ZenIV.linux.org.uk>
References: <sIiXQlfwS3D.A.81.dj7KKB@chimera> <AN6kEAA5GQ.A.NkB.9j7KKB@chimera> <20090607171418.GA22756@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607171418.GA22756@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 01:14:18PM -0400, Theodore Tso wrote:
> On Sun, Jun 07, 2009 at 12:06:22PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13232
> > Subject		: ext3/4 with synchronous writes gets wedged by Postfix
> > Submitter	: David Watson <kernel-nospam@dbwatson.ukfsn.org>
> > Date		: 2009-05-03 19:46 (36 days old)
> 
> Al Viro has the fix for this in the for-next branch of his vfs-2.6 git
> tree, as commit ID 72a43d63: "ext3/4 with synchronous writes gets
> wedged by Postfix".  I pinged Al previously about pushing this as a
> regression fix for 2.6.30, but never got a response.  At this point we
> might as well wait for it to go into the 2.6.31 merge window, and then
> we can ask for it to go into the 2.6.30.y and 2.6.29.y stable trees.

It's in mainline now, actually.  But yes, we need it in -stable as well.
