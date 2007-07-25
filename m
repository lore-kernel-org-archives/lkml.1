Return-Path: <linux-kernel-owner+w=401wt.eu-S935036AbXGYSbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935036AbXGYSbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbXGYSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3016 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760935AbXGYSaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:12 -0400
Date: Wed, 25 Jul 2007 13:41:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: nigel@suspend2.net
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, Rafael Wysocki <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?
Message-ID: <20070725134158.GB9256@ucw.cz>
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191218.32730.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191459.20998.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Thursday 19 July 2007 14:09:56 Agarwal, Lomesh wrote:
> > Can you point me to code where kernel captures process in signal
> > handling and code which runs after suspend to ram is finished?
> 
> Sure.
> 
> It's in kernel/signal.c (get_signal_to_deliver) for x86 and x86_64, and 
> arch/<name>/kernel/signal.c for other arches. The support for other arches is 
> the place x86 & x86_64 used to use - I wonder if they should be going away 
> (Rafael cc'd to raise this point with him).

...and you want to look at kernel/power/process.c, too.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
