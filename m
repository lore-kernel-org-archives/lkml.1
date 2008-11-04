Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYKDSoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYKDSoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbYKDSnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:43:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52209 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332AbYKDSny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:43:54 -0500
Message-ID: <491097DA.9040204@garzik.org>
Date: Tue, 04 Nov 2008 13:43:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Doug Nazar <nazard@dragoninc.ca>
CC: "'J. Bruce Fields'" <bfields@citi.umich.edu>,
       "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc3 truncates nfsd results
References: <000301c93eaa$fae98460$f0bc8d20$@ca>
In-Reply-To: <000301c93eaa$fae98460$f0bc8d20$@ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Nazar wrote:
> Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
> breaks the nfsd server. Bisected it back to this commit and reverting it
> fixes the problem.
> 
> However, it only happens on certain machines even with the same kernel &
> filesystem (ext3). I've two groups of similar computers, each group running
> identical kernels. The ones listing only ~250 files are of course in error.
> Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
> showed the incorrect number.

I'm seeing "weirdness" on my NFS4-mounted home directory (client and 
server are both x86-64 2.6.28-rc) -- gconfd locking up, and other 
desktop gadgets breaking.  2.6.27 works great.

I'll try reverting this and see if the behavior improves, thanks for the 
pointer...

	Jeff



