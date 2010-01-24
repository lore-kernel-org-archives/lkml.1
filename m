Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974Ab0AXXNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0AXXNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 18:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806Ab0AXXNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 18:13:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0AXXNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 18:13:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johan Hovold <jhovold@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: [Bug #15038] drm/ksm: fbdev blanking regression
Date: Mon, 25 Jan 2010 00:13:48 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Simmons <jsimmons@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.4_F.ZKMXLB@chimera> <20100124224516.GA20080@localhost>
In-Reply-To: <20100124224516.GA20080@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001250013.48523.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Johan Hovold wrote:
> On Sun, Jan 24, 2010 at 11:04:36PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15038
> > Subject		: drm/ksm: fbdev blanking regression
> > Submitter	: Johan Hovold <jhovold@gmail.com>
> > Date		: 2010-01-06 17:00 (19 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=731b5a15a3b1474a41c2ca29b4c32b0f21bc852e
> > References	: http://marc.info/?l=linux-kernel&m=126279726418748&w=4
> > Handled-By	: James Simmons <jsimmons@infradead.org>
> 
> Issue remains in rc5.

Thanks for the update.

OK, we know what commit broke things, we don't seem to know how to fix it,
so perhaps it's time to revert that commit?

Rafael
