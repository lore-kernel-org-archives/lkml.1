Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbYBSW2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbYBSW2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbYBSW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:28:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58270 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756538AbYBSW2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:28:07 -0500
Date: Tue, 19 Feb 2008 23:28:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Jackson <pj@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, marcelo@kvack.org, daniel.spang@gmail.com,
       riel@redhat.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Message-ID: <20080219222828.GB28786@elf.ucw.cz>
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com> <20080217084906.e1990b11.pj@sgi.com> <20080219145108.7E96.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080219090008.bb6cbe2f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219090008.bb6cbe2f.pj@sgi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-19 09:00:08, Paul Jackson wrote:
> Kosaki-san wrote:
> > Thank you for wonderful interestings comment.
> 
> You're most welcome.  The pleasure is all mine.
> 
> > you think kill the process just after swap, right?
> > but unfortunately, almost user hope receive notification before swap ;-)
> > because avoid swap.
> 
> There is not much my customers HPC jobs can do with notification before
> swap.  Their jobs either have the main memory they need to perform the
> requested calculations with the desired performance, or their job is
> useless and should be killed.  Unlike the applications you describe,
> my customers jobs have no way, once running, to adapt to less
> memory.

Sounds like a job for memory limits (ulimit?), not for OOM
notification, right?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
