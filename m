Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbZBYPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbZBYPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZBYPAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:00:03 -0500
Received: from THUNK.ORG ([69.25.196.29]:52107 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbZBYPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:00:00 -0500
Date: Wed, 25 Feb 2009 09:59:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Yang Hongyang <yanghy@cn.fujitsu.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-doc@vger.kernel.org, mtk.manpages@gmail.com, rdunlap@xenotime.net
Subject: Re: Documentation:Update the INDEX of the documents
Message-ID: <20090225145950.GJ7064@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Yang Hongyang <yanghy@cn.fujitsu.com>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, mtk.manpages@gmail.com,
	rdunlap@xenotime.net
References: <49A4F06B.6030205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A4F06B.6030205@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 03:16:59PM +0800, Yang Hongyang wrote:
> There are so many 00-INDEX file that are missing description of the
> current files in the dir.  Such as 00-INDEX in
> Documentation/x86/,Documentation/networking/,Documentation/ and so
> on.
> 
> It's a large amount of work for someone to go through all these
> documents and make summaries.
> 
> I'm willing to do some of the work but if someone else pick these
> up(especially the authors of these new files) it will be a great
> help.^_^

Before you embark on this large amount of work, we should probably ask
a question first --- how useful are the 00-INDEX files?  I don't find
them particularly interesting, given that my normal way of finding
documentation in the Documentation directory is:

find . -type f | xargs grep <keyword>

Or, if I have a git tree of the Linux sources handy:

git grep <keyword> -- Documentation

If folks do find the 00-INDEX files useful, my suggestion would be to
make a way of automatically extracting them from the individual files
and/or directories, and then making the 00-INDEX files to be
automatically generated.

						- Ted
