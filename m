Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXIQVEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXIQVEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbXIQVD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:03:56 -0400
Received: from www.osadl.org ([213.239.205.134]:38528 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753869AbXIQVDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:03:55 -0400
Subject: Re: [3/3] 2.6.23-rc6: known regressions v2
From: Thomas Gleixner <tglx@linutronix.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
       Thomas Voegtle <tv@lio96.de>, Soeren Sonnenburg <kernel@nn7.de>
In-Reply-To: <200709172251.07769.arekm@maven.pl>
References: <46EB3EF8.6040103@googlemail.com>
	 <200709172144.43761.arekm@maven.pl> <1190058463.2995.14.camel@chaos>
	 <200709172251.07769.arekm@maven.pl>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 23:03:48 +0200
Message-Id: <1190063028.2995.53.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 22:51 +0200, Arkadiusz Miskiewicz wrote:
> > >     clockevents: fix resume logic
> >
> > Linus pulled a series of patches which are addressing this issue into
> > his tree yesterday. Can you please retest against current git ?
> 
> Looks like the problem is fixed in current git for me. Thanks!

Thanks for testing.

> ps. The description about vaio not resuming without key pressing matches what 
> I was seeing here on thinkpad z60m, too.

Sigh, there were several subtle reason why you would need to press keys
during resume. The one you are referring to is the one which is the most
obscure. It would be nice if you could revert that particular one and
check whether it still works on your box.

	tglx


