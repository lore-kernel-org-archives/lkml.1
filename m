Return-Path: <linux-kernel-owner+w=401wt.eu-S1763853AbYESWkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763853AbYESWkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761135AbYESWkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:40:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbYESWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:40:00 -0400
Date: Tue, 20 May 2008 00:39:59 +0200
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080519223959.GA14602@atrey.karlin.mff.cuni.cz>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805191439.36577.chris.mason@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 19 May 2008, Chris Mason wrote:
> >
> > Here's a test workload that corrupts ext3 50% of the time on power fail
> > testing for me.  The machine in this test is my poor dell desktop (3ghz,
> > dual core, 2GB of ram), and the power controller is me walking over and
> > ripping the plug out the back.
> 
> Here's a new version that still gets about corruptions 50% of the time, but 
> does it with fewer files by using longer file names (240 chars instead of 160 
> chars).
> 
> I tested this one with a larger FS (40GB instead of 2GB) and larger log (128MB 
> instead of 32MB).  barrier-test -s 32 -p 1500 was still able to get a 50% 
> corruption rate on the larger FS.
  Hmm, this is worse than I'd have expected :( If it is that bad, I
think we should really enable them by default... I can give your script
a try on my test machine when I get back (which is next week).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
