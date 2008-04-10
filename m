Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYDJQPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYDJQPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbYDJQPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:15:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:56177 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757045AbYDJQPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:15:16 -0400
Date: Thu, 10 Apr 2008 18:15:15 +0200
From: Jan Kara <jack@suse.cz>
To: Diego Calleja <diegocg@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080410161515.GG20656@duck.suse.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee> <200804101555.58643.mhocko@suse.cz> <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz> <20080410142700.GC6725@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804101628000.3896@jikos.suse.cz> <20080410180335.6a748c78.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410180335.6a748c78.diegocg@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-04-08 18:03:35, Diego Calleja wrote:
> El Thu, 10 Apr 2008 16:31:09 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> escribió:
> 
> > I think this is worth fixing.
> 
> This question comes very often, and Linus even wrote a patch
> (http://lkml.org/lkml/2006/4/13/124 , http://lkml.org/lkml/2006/4/13/130)
> 
> But apparently there's no much interest in fixing it, because it would
> slow down some workloads...
  Well, what Linus writes about is a different issue (and with a more
costly solution). Here we are concerned just with the problem that
  file->f_pos = pos;
isn't atomic on some archs.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
