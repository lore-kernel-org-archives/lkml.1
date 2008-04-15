Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbYDOPcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbYDOPcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYDOPcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:32:23 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52473 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbYDOPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:32:22 -0400
Date: Tue, 15 Apr 2008 11:32:21 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415153221.GD7387@csclub.uwaterloo.ca>
References: <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415085740.GA7603@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:57:41AM +0200, Pavel Machek wrote:
> Not if you tried to do checking from ptrace monitor.
> 
> And heck, yes, it is very confusing to see
> 
> seek(somewhere)
> write()
> 
> ond ptrace and write going somewhere else.

Yes bugs are confusing.  An application can't do this on demand so you
can't write code that relies on the effect between threads.  So it would
only be a bug, not a bizare feature (that wouldn't even work on 64bit
machines).

-- 
Len Sorensen
