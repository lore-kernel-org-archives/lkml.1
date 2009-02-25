Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZBYTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZBYTHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbZBYTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:07:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42334 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbZBYTHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:07:31 -0500
Date: Wed, 25 Feb 2009 12:07:12 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/8] Aufs2 documents
Message-ID: <20090225190712.GU16891@parisc-linux.org>
References: <7558.1235374266@jrobl> <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 12:50:54PM -0500, David P. Quigley wrote:
> I think it would be useful to see the source code for AUFS2 posted to
> LKML. One of the questions I have not which doesn't seem to be addressed
> in these documents is how robust is your xattr support and are you
> making the appropriate LSM calls to make this usable with SELinux and
> Smack. Also from a labeling perspective you have a very interesting
> question of which label do you select when unifying directories. If you
> have a/foo and b/foo each with different labels which do you choose.
> Based on the history of Union type file systems I would suspect the
> answer is whichever branch is listed first. 

That would provide an interesting way to bypass security protections on
a directory.  I suspect it should deny access if *any* of the unioned
directories would deny access.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
