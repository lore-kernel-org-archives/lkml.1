Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZKHRE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZKHRE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZKHREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:04:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53012 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbZKHREz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:04:55 -0500
Date: Sun, 8 Nov 2009 18:04:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] show per-process swap usage via procfs
Message-ID: <20091108170453.GA1372@ucw.cz>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1> <20091105082357.54D3.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0911051003060.25718@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0911051003060.25718@V090114053VZO-1>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-05 10:04:01, Christoph Lameter wrote:
> On Thu, 5 Nov 2009, KOSAKI Motohiro wrote:
> 
> > > On Wed, 4 Nov 2009, KAMEZAWA Hiroyuki wrote:
> > >
> > > > Now, anon_rss and file_rss is counted as RSS and exported via /proc.
> > > > RSS usage is important information but one more information which
> > > > is often asked by users is "usage of swap".(user support team said.)
> > >
> > > Hmmm... Could we do some rework of the counters first so that they are per
> > > cpu?
> >
> > per-cpu swap counter?
> > It seems overkill effort....
> 
> The other alternative is to use atomic ops which are significantly slower
> and have an impact on critical sections.

...but compared to disk i/o, overhead should be almost zero, right?
Keep it simple...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
