Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZJZRYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZJZRYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZJZRYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:24:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37524 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbZJZRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:24:38 -0400
Date: Mon, 26 Oct 2009 18:24:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026172434.GI25725@elf.ucw.cz>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
 <20091023161006.GA1580@ucw.cz>
 <20091026165518.GE2792@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026165518.GE2792@tuxdriver.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-10-26 12:55:19, John W. Linville wrote:
> On Fri, Oct 23, 2009 at 06:10:06PM +0200, Pavel Machek wrote:
> > On Tue 2009-10-20 14:17:07, John W. Linville wrote:
> > > Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> > > several years this driver has only seen API "bombing-run" changes, and
> > > few people ever had the hardware.  This driver represents unnecessary
> > > ongoing maintenance for no clear benefit.
> > 
> > This seems like abuse of the staging process.
> 
> My mailbox has been filling-up with discussions of using staging like
> this for the past few weeks.  I'm reasonably certain those threads
> were on the public lists.

Yes and I skimmed those.

> > There's no TODO to say what needs to be fixed. You just don't want to
> > maintain it. Because there's nothing to fix, noone has reason to patch
> > it, and the (working, good enough) driver will just be removed.
> 
> "ongoing maintenance for no clear benefit" -- that is what is wrong
> with it.

And how is moving to staging helping with that?

Anyway, for moving to staging, TODO file describing what needs to be
fixed before it is brought back was listed as a requirement. So it
looks like staging is wrong tool for the job.

> > What about removing it in the regular way, that's
> > Documentation/feature-removal.txt ?
> 
> This has been discussed recently as an alternative for unmaintained
> drivers.  I suspect this is better than adding a note to a file that
> no one reads...

There are other alternatives, like printk() in module_init...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
