Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYCNSfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYCNSfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYCNSey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:34:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1827 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753407AbYCNSey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:34:54 -0400
Date: Fri, 14 Mar 2008 19:34:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Mike Galbraith <efault@gmx.de>, Jan Knutar <jk-lkml@sci.fi>,
       linux-kernel@vger.kernel.org, Hans-Peter Jansen <hpj@urpla.net>,
       Jiri Kosina <jkosina@suse.cz>, David Newall <davidn@davidnewall.com>,
       Theodore Tso <tytso@mit.edu>, "Fred ." <eldmannen@gmail.com>
Subject: Re: Keys get stuck
Message-ID: <20080314183438.GB6722@ucw.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br> <47D937A2.9070305@aitel.hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D937A2.9070305@aitel.hist.no>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 15:18:10, Helge Hafting wrote:
> Carlos R. Mafra wrote:
> >On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith 
> >wrote:
> >  
> >>[...]
> >>Swap can definitely keep X off the cpu for extended 
> >>periods,
> >>[...]
> >>    
> >
> >So I would like to ask if swap letting X (and 
> >everything else
> >in my experience) out of the cpu for extended periods is
> >considered normal behaviour, in the sense that nobody is
> >trying to "fix" it (due to it being considered 
> >impossible
> >to fix)...?
> >  
> Yes, this is perfectly normal. A heavily swapping machine
> will swap out parts of X.
> 
> Now, if X has a need for low-latency for keyboard 
> handling,

If X needs low-latency for keyboard, X is misdesigned.

Kernel already provides timestamped input events...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
