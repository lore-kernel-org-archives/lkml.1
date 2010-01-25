Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153Ab0AYGch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab0AYGch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586Ab0AYGcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:32:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab0AYGcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:32:35 -0500
Subject: Re: [Bug #15038] drm/ksm: fbdev blanking regression
From: Dave Airlie <airlied@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johan Hovold <jhovold@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Simmons <jsimmons@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201001250013.48523.rjw@sisk.pl>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.4_F.ZKMXLB@chimera> <20100124224516.GA20080@localhost>
	 <201001250013.48523.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 16:28:05 +1000
Message-ID: <1264400885.8478.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 00:13 +0100, Rafael J. Wysocki wrote:
> On Sunday 24 January 2010, Johan Hovold wrote:
> > On Sun, Jan 24, 2010 at 11:04:36PM +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15038
> > > Subject		: drm/ksm: fbdev blanking regression
> > > Submitter	: Johan Hovold <jhovold@gmail.com>
> > > Date		: 2010-01-06 17:00 (19 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
> > > References	: http://marc.info/?l=linux-kernel&m=126279726418748&w=4
> > > Handled-By	: James Simmons <jsimmons@infradead.org>
> > 
> > Issue remains in rc5.
> 
> Thanks for the update.
> 
> OK, we know what commit broke things, we don't seem to know how to fix it,
> so perhaps it's time to revert that commit?

Just sent revert of the broken bit to Linus.

Dave.


