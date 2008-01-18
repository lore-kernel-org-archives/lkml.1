Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbYARNwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbYARNwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYARNwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:52:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:35130 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYARNwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:52:44 -0500
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, bunk@kernel.org, Takashi Iwai <tiwai@suse.de>,
       Shaohua Li <shaohua.li@intel.com>, Jay Vosburgh <fubar@us.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org>
References: <200801180035.42878.rjw@sisk.pl>
	 <20080117155809.7ebc3bb7.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0801171606300.2957@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 07:52:20 -0600
Message-Id: <1200664340.7524.7.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 16:18 -0800, Linus Torvalds wrote:
> 
> On Thu, 17 Jan 2008, Andrew Morton wrote:
> > 
> > There are thirteen regressions for which we have patches but they aren't
> > merged.  That seems rather high.
> 
> I think a number of them have been merged, or the thing that caused them 
> reverted. For example.
> 
> > > Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
> > > Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
> > > Date		: 2007-11-02 09:54
> > > References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
> > > Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view
> 
> Isn't this the same write-back-related thing, reverted by 
> c23f72cae9523d29ff94eec8f30ccbdaf234b20e?

The bug originally described a problem on reiserfs, which I believe is
fixed.  A second problem was found on jfs, which probably should have
resulted in a new bug being opened.  The jfs patch is not in mainline
yet.  There are 3 jfs bug fixes ready for mainline in:
git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
for-linus

Alternately, you could pull just
29a424f28390752a4ca2349633aaacc6be494db5 from that tree.  (Can you do
this without a tag?)  It is the first unmerged patch in the tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

