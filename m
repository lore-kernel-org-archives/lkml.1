Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbYD1NzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbYD1NzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbYD1NzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:55:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:50042 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbYD1NzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:55:01 -0400
Date: Mon, 28 Apr 2008 15:54:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] x86: Modify Kconfig to allow up to 4096 cpus
Message-ID: <20080428135459.GA3704@atrey.karlin.mff.cuni.cz>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com> <20080426001549.014201000@polaris-admin.engr.sgi.com> <20080427103933.GA5168@ucw.cz> <20080428133806.GC3973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428133806.GC3973@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Fri 2008-04-25 17:15:49, Mike Travis wrote:
> > >   * Increase the limit of NR_CPUS to 4096 and introduce a boolean
> > >     called "MAXSMP" which when set (e.g. "allyesconfig"), will set
> > >     NR_CPUS = 4096 and NODES_SHIFT = 9 (512).
> > 
> > Why is redundant option 'maxsmp' a good idea?
> 
> because this way randconfig can trigger it and can configure all the 
> otherwise randconfig-invisible [or just plain unlikely] numerics and 
> options up to their max.
> 
> I found 2-3 "large box" bugs via that way already.

Should we improve randconfig to select numeric values when range is
given, too?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
