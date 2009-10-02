Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZJBUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZJBUpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZJBUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:45:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58036 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbZJBUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:45:31 -0400
Date: Fri, 2 Oct 2009 22:45:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20091002204528.GC29734@elf.ucw.cz>
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins> <adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com> <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <ada3a61rc3j.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada3a61rc3j.fsf@cisco.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In the end this seems to just take the ummunotify code I have, and make
> it be a new type of perf counter instead of a character special device.
> I'd actually be OK with that, since having an oddball new char dev
> interface is not particularly nice.  But on the other hand just
> multiplexing a new type of thing under perf events is not all that much
> better.  What do you think?

I really hate the strange character device. So if you can hide it in
tracing infrastructure, I'd certainly like that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
