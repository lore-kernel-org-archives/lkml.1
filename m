Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYKITKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYKITKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 14:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYKITKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 14:10:07 -0500
Received: from mail.fieldses.org ([66.93.2.214]:59972 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbYKITKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 14:10:06 -0500
Date: Sun, 9 Nov 2008 14:09:51 -0500
To: Jeff Garzik <jeff@garzik.org>
Cc: Doug Nazar <nazard@dragoninc.ca>,
       "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc3 truncates nfsd results
Message-ID: <20081109190951.GD25568@fieldses.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca> <491097DA.9040204@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491097DA.9040204@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 01:43:38PM -0500, Jeff Garzik wrote:
> Doug Nazar wrote:
>> Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
>> breaks the nfsd server. Bisected it back to this commit and reverting it
>> fixes the problem.
>>
>> However, it only happens on certain machines even with the same kernel &
>> filesystem (ext3). I've two groups of similar computers, each group running
>> identical kernels. The ones listing only ~250 files are of course in error.
>> Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
>> showed the incorrect number.
>
> I'm seeing "weirdness" on my NFS4-mounted home directory (client and  
> server are both x86-64 2.6.28-rc) -- gconfd locking up, and other  
> desktop gadgets breaking.  2.6.27 works great.
>
> I'll try reverting this and see if the behavior improves, thanks for the  
> pointer...

Any more details on that "weirdness"?

--b.
