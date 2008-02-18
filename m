Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYBRVyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYBRVyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbYBRVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:53:58 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47636 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753704AbYBRVx5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:53:57 -0500
Date: Tue, 19 Feb 2008 08:53:44 +1100
From: David Chinner <dgc@sgi.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inode leak in 2.6.24?
Message-ID: <20080218215344.GM155407@sgi.com>
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hcg9hkpp.fsf@szonett.ki.iif.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 12:18:58AM +0100, Ferenc Wagner wrote:
> Hi,
> 
> 5 days ago I pulled the git tree (HEAD was
> 25f666300625d894ebe04bac2b4b3aadb907c861), added two minor patches
> (the vmsplice fix and the GFS1 exports), compiled and booted the
> kernel.  Things are working OK, but I noticed that inode usage has
> been steadily rising since then (see attached graph, unless lost in
> transit).  The real filesystems used by the machine are XFS.  I wonder
> if it may be some kind of bug and if yes, whether it has been fixed
> already.  Feel free to ask for any missing information.

Output of /proc/slabinfo, please. If you could get a sample when the
machine has just booted, one at the typical post-boot steady state
as well as one after it has increased well past normal, it would
help identify what type of inode is increasing differently.

Also, can you tell us what metrics you are graphing (i.e. where
in /proc or /sys you are getting them from)?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
