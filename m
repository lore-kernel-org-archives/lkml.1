Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYCMRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYCMRPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbYCMRP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:15:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3909 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756856AbYCMRPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:15:25 -0400
Date: Thu, 13 Mar 2008 18:14:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Newall <davidn@davidnewall.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080313171425.GA4840@ucw.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7B428.6010804@davidnewall.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 21:14:56, David Newall wrote:
> Jiri Kosina wrote:
> > Very probably this is due to broken way how X themselves implement 
> > auto-repeat, instead of using kernel-provided auto-repeat functionality.
> 
> It should be said that X implements auto-repeat out of necessity.  While
> the kernel can report key down and up events, its further interpretation
> of those events is not appropriate.  Many combinations of events are
> possible, such as keyboard plus mouse, and this precludes the kernel
> from providing a full interpretation.  It would be wrong for it to even
> try.  X is the proper place to implement auto-repeat for X.

No.

hw is proper place to implement autorepeat, and along with some
buffering, it has chance to work. Kernel is not real-time, and X are
definitely not real-time, while autorepeat is real-time operation.

It actually mostly works in ps/2 case. Buffer in hardware means that
pretty big interrupt delays can be tolerated without problems.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
