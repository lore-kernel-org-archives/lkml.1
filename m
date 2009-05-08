Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZEHV6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZEHV6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbZEHV6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:58:30 -0400
Received: from mail.crca.org.au ([67.207.131.56]:57139 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZEHV63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:58:29 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200905082144.57955.bzolnier@gmail.com>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <20090507215112.GC14611@elf.ucw.cz>
	 <1241746459.19600.246.camel@nigel-laptop>
	 <200905082144.57955.bzolnier@gmail.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 07:59:31 +1000
Message-Id: <1241819971.19600.288.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2009-05-08 at 21:44 +0200, Bartlomiej Zolnierkiewicz wrote:
> Please proceed to Plan B then.
> 
> Adding third core code framework to do the same thing is out of question
> (probably same should have been said about adding second one in the past).

Why? We have plenty of history of having multiple implementations of
things (slub, slab and slob...).

> Moreover you will for sure hit much more regressions than you expect
> (I "love" seeing over and over again when people/companies get trapped
> into fallacy of superiority of their _own_ solution).

That's just wrong. TuxOnIce deliberately doesn't remove any of swsusp or
uswsusp so that there's no chance of users having regressions. It
provides the _option_ of being a drop in replacement for swsusp, but it
doesn't force users to take that option.

Regressions happen at the moment because TuxOnIce isn't included in
vanilla. Users update from one version of stable to the next or from one
version of head to the next and expect TuxOnIce to keep working, and it
doesn't always do that because of changes to the vanilla code that
require an updated patch.

> I really wouldn't consider teaming with Rafael to work on "swsuspOnTux"
> (evolving the in-kernel code while re-using chunks of TuxOnIce code) as
> a bad Plan B.  It has the potential of resulting in a solution clearly
> superior to all existing ones (TuxOnIce included).

If there are features in swsusp that TuxOnIce is lacking, or features to
uswsusp that TuxOnIce is lacking, please tell me what they are and I'll
implement them. In saying this, I don't deny that TuxOnIce code can
still be improved - there's a lot I'd still like to do.

Regards,

Nigel

