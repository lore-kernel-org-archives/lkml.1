Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZEGVrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZEGVrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZEGVqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:46:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761909AbZEGVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:46:51 -0400
Date: Thu, 7 May 2009 23:46:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Price <moptop99@gmail.com>,
       linux-kernel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090507214645.GB14611@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905071945.45928.rjw@sisk.pl> <f22f52180905071052o68e3999co8e353d46aa60b47c@mail.gmail.com> <200905072022.15202.rjw@sisk.pl> <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-07 20:57:44, Fabio Comolli wrote:
> On Thu, May 7, 2009 at 8:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 07 May 2009, Matt Price wrote:
> >> On Thu, May 7, 2009 at 1:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Thursday 07 May 2009, U Kuehn wrote:
> >> >> Pavel Machek wrote:
> >> >> >> T
> >> > Also, as you can see from my previous message, I'm not a big fan of fighting
> >> > over this once again.  Lets try to work together to do something productive
> >> > instead, shall we?
> >> >
> >>
> >> thank you rafael.  i would really like to see the fighting stop, too.
> >> Perhaps the best palce to start would be to look directly at the
> >> patches and, if there are weaknesses, discuss how to improve them?
> >
> > Yes, I've talked about that already with Nigel and there's a kind of a plan.
> >
> 
> Well, if I may jump in I suggest you start with the full-memory image
> functionality. This is in my opinion the biggest advantage in tuxonice
> vs. uswsusp.

Neither tuxonice nor swsusp can write full-memory image (it is mostly
impossible to do in unlikely case of all memory is consumed by
kmalloc). Now, tuxonice can produce bigger images than swsusp...

Rafael had short patch for similar efect some time ago, but we could
not find anyone to really review it...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
