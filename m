Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbXDXBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbXDXBSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXDXBSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:18:39 -0400
Received: from THUNK.ORG ([69.25.196.29]:52455 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbXDXBSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:18:38 -0400
Date: Mon, 23 Apr 2007 21:17:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-ID: <20070424011753.GD1663@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Eric Hopper <hopper@omnifarious.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <462C4D32.4000909@redhat.com> <Pine.LNX.4.64.0704230611430.25153@server.thyself> <462C5034.9090403@redhat.com> <Pine.LNX.4.64.0704230640540.25153@server.thyself> <20070423010445.454eda63.akpm@linux-foundation.org> <20070423135216.GA2744@omnifarious.org> <20070423225640.GA1663@thunk.org> <462D46DF.4090802@zytor.com> <20070424001934.GC1663@thunk.org> <462D4FE1.5040406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462D4FE1.5040406@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 05:31:29PM -0700, H. Peter Anvin wrote:
> Heh.  sys_read_tree() -- walk a directory tree and return it as a data 
> structure in memory :)

But maybe you don't want every single file in the directory, but some
subset of the files in the directory tree.  So before you know it:

sys_fs_sql("SELECT port,userid,daemon FROM /etc/inetd.conf.d "
	"WHERE protocol=='tcp'", buf, sizeof(buf));

The question is where do you stop on the slippery slope, and is it
really all that harder than simply parsing a /etc/gitconfig or
/etc/e2fsck.conf file.  There are plenty of parsers or database
libraries already written, and many of them are quite efficient.  And
personally, I'd much rather edit a single /etc/gitconfig or
/etc/e2fsck.conf file using emacs than have to cd through 3 or 4
levels of directories to edit each 2-3 byte file one at a time.  But
to each their own....

					- Ted
