Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZJZRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZJZRBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZJZRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:01:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43163 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZJZRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:01:15 -0400
Date: Mon, 26 Oct 2009 12:55:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 1/4] strip: move driver to staging
Message-ID: <20091026165518.GE2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com> <20091023161006.GA1580@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023161006.GA1580@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 06:10:06PM +0200, Pavel Machek wrote:
> On Tue 2009-10-20 14:17:07, John W. Linville wrote:
> > Move the strip ("Starmode Radio IP") driver to drivers/staging.  For
> > several years this driver has only seen API "bombing-run" changes, and
> > few people ever had the hardware.  This driver represents unnecessary
> > ongoing maintenance for no clear benefit.
> 
> This seems like abuse of the staging process.

My mailbox has been filling-up with discussions of using staging like
this for the past few weeks.  I'm reasonably certain those threads
were on the public lists.

> There's no TODO to say what needs to be fixed. You just don't want to
> maintain it. Because there's nothing to fix, noone has reason to patch
> it, and the (working, good enough) driver will just be removed.

"ongoing maintenance for no clear benefit" -- that is what is wrong
with it.

> It also marks driver as broken when it is not...

I didn't mark it broken, I proposed moving it to staging.  As for
whether or not it actually is broken, how do you know?

The drivers in this thread are for pre-802.11 devices -- old ones
(e.g. ISA) at that.  If we actually have users that are willing
to maintain them then maybe that is fine.  But I don't see the
benefit of maintaining these simply as extra targets for API change
"bombing runs"...

> What about removing it in the regular way, that's
> Documentation/feature-removal.txt ?

This has been discussed recently as an alternative for unmaintained
drivers.  I suspect this is better than adding a note to a file that
no one reads...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
