Return-Path: <linux-kernel-owner+w=401wt.eu-S1762851AbZAHVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762851AbZAHVcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZAHVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:32:10 -0500
Received: from THUNK.ORG ([69.25.196.29]:44840 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZAHVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:32:09 -0500
Date: Thu, 8 Jan 2009 16:31:58 -0500
From: Theodore Tso <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       ccache@lists.samba.org
Subject: Re: [REGRESSION] Recent change to kernel spikes out ccache/distcc
Message-ID: <20090108213157.GB922@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dave Jones <davej@redhat.com>, Jan Beulich <jbeulich@novell.com>,
	Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
	ccache@lists.samba.org
References: <E1LKDeQ-0002xz-7E@closure.thunk.org> <20090107131221.GA17110@mit.edu> <20090108191703.GA11273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108191703.GA11273@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 02:17:03PM -0500, Dave Jones wrote:
> 
> Fedora rawhide users noticed this same problem this morning too,
> when I pushed out a build that eats up a gig of diskspace thanks
> to the number of modules we have, that are all afflicted by this problem.
> 
> I'll have to revert  ad7a953c for our builds to continue tracking mainline
> without monopolising the diskspace in the Fedora build system.

Note: you'll probably also have revert 9bb48247 (allow stripping of
generated symbols under CONFIG_KALLSYMS_ALL) since I believe it
depends on ad7a953c.

						- Ted
