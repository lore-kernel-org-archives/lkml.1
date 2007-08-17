Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbXHQAp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbXHQAp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXHQAps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:45:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbXHQApr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:45:47 -0400
Date: Thu, 16 Aug 2007 20:45:44 -0400
From: Dave Jones <davej@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070817004544.GA27058@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <p73hcnen7w2.fsf@bingen.suse.de> <20070805150029.GB28263@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070805150029.GB28263@thunk.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 11:00:29AM -0400, Theodore Tso wrote:

 > P.S.  Yet alternative is to specify noatime on an individual
 > file/directory basis.  We've had this capability for a *long* time,
 > and if a distro were to set noatime for all files in certain
 > hierarchies (i.e., /usr/include) and certain top-level directories
 > (since the chattr +A flag is inherited)

This came across my mind again earlier, and I went digging.
Can you explain how this works?

I've eyeballed the ext2/ext3 code, and feel like I'm missing something obvious.
I'm guessing that for eg, with /usr/include/stdio.h, we check the inodes
for all four parts of path, and if any of them are +A we avoid the
atime update ?  If so, where does that inheritance happen in the code?

	Dave

-- 
http://www.codemonkey.org.uk
