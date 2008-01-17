Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYARAAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYARAAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYAQX7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:59:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYAQX7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:59:50 -0500
Date: Thu, 17 Jan 2008 15:58:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       bunk@kernel.org, Dave Kleikamp <shaggy@austin.ibm.com>,
       Takashi Iwai <tiwai@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Jay Vosburgh <fubar@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Message-Id: <20080117155809.7ebc3bb7.akpm@linux-foundation.org>
In-Reply-To: <200801180035.42878.rjw@sisk.pl>
References: <200801180035.42878.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 00:35:41 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 reported since
> 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> of. __If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list. __Also, please let me know if any of the
> entries below are invalid.
> 
> Listed regressions statistics:
> 
>   Date          Total  Pending  Unresolved
>   ----------------------------------------
>   Today           157       25          12

There are thirteen regressions for which we have patches but they aren't
merged.  That seems rather high.

(cc's added).

Guys, can we get things wrapped up here please?

> 
> Subject		: [2.6.24-rc6] pdflush still stuck in D state regression
> Submitter	: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
> Date		: 2007-11-02 09:54
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9291
> Handled-By	: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14219&action=view
> 
> 
> Subject		: snd_hda_intel 2.6.24-rc2 bug: interrupts don't always work on Lenovo X60s
> Submitter	: Roland Dreier <rdreier@cisco.com>
> Date		: 2007-11-08 14:55
> References	: http://lkml.org/lkml/2007/11/8/255
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9332
> Handled-By	: Takashi Iwai <tiwai@suse.de>
> 		  Ingo Molnar <mingo@elte.hu>
> Patch		: http://lkml.org/lkml/2007/11/16/66
> 
> 
> Subject		: jiffies counter leaps in 2.6.24-rc3
> Submitter	: Stefano Brivio <stefano.brivio@polimi.it>
> Date		: 2007-11-29 08:36
> References	: http://lkml.org/lkml/2007/11/24/53
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9475
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://lkml.org/lkml/2007/12/7/132
> 
> 
> Subject		: 2.6.24-rc4 hwmon it87 probe fails
> Submitter	: Mike Houston <mikeserv@bmts.com>
> Date		: 2007-12-06 17:10
> References	: http://lkml.org/lkml/2007/12/4/466
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9514
> Handled-By	: Shaohua Li <shaohua.li@intel.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14267&action=view
> 
> 
> Subject		: RTNL: assertion failed at net/ipv6/addrconf.c (2164)/RTNL: assertion failed at net/ipv4/devinet.c (1055)
> Submitter	: Krzysztof Oledzki <olel@ans.pl>
> Date		: 2007-12-11 03:20
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9543
> Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> 		  Herbert Xu <herbert@gondor.apana.org.au>
> 		  Jay Vosburgh <fubar@us.ibm.com>
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=9543#c6
> 
> 
> Subject		: PATA_HPT37X embezzles two ports
> Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> Date		: 2007-12-12 11:05
> References	: http://lkml.org/lkml/2007/12/12/161
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
> Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Patch		: http://lkml.org/lkml/2007/1/4/161
> 
> 
> Subject		: wake on lan fails with sky2 module
> Submitter	: cpo <supersud501@yahoo.de>
> Date		: 2008-01-09 13:05
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9721
> 		  http://marc.info/?t=119992349300001&r=1&w=4
> Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14455&action=view
> 
> 
> Subject		: psmouse.c: GlidePoint at isa0060/serio1/input0 lost sync at byte 1
> Submitter	: "Vegard Nossum" <vegard.nossum@gmail.com>
> Date		: 2007-11-14 21:26
> References	: http://lkml.org/lkml/2007/11/14/363
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9727
> Handled-By	: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Patch		: http://lkml.org/lkml/2008/1/16/151
> 

Looks like Dmitry has just sent this in to Linus.

> 
> Subject		: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
> Submitter	: Benjamin LaHaise <bcrl@kvack.org>
> Date		: 2008-01-06 23:03
> References	: http://lkml.org/lkml/2008/1/6/248
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9736
> Handled-By	: "Eric W. Biederman" <ebiederm@xmission.com>
> Patch		: http://lkml.org/lkml/2008/1/7/60
> 
> 
> Subject		: Oops on boot from laptop mode writing to /proc/acpi/processor/CPU0/throttling
> Submitter	: Simon Huggins <huggie@earth.li>
> Date		: 2008-01-14 11:19
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9747
> Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14456&action=view
> 
> 
> Subject		: fs/hfs/btree.c: new NULL dereference
> Submitter	: Adrian Bunk <bunk@kernel.org>
> Date		: 2008-01-14 13:17
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9748
> Handled-By	: Eric Sandeen <sandeen@redhat.com>
> Patch		: http://lkml.org/lkml/2008/1/14/365

I sent this fix to Linus a few minutes ago.

> 
> Subject		: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
> Submitter	: Frans Pop <elendil@planet.nl>
> Date		: 2008-01-15 06:25
> References	: http://lkml.org/lkml/2008/1/15/4
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9757
> Handled-By	: David Miller <davem@davemloft.net>
> Patch		: http://lkml.org/lkml/2008/1/16/2
> 

I think Dave just sent this one.

> 
> Subject		: radeonfb and Xpress 200m 5955
> Submitter	: Alex <alevkovich@tut.by>
> Date		: 2008-01-16 01:33
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9762
> Handled-By	: Geert Uytterhoeven <geert@linux-m68k.org>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=14481&action=view
> 

I just sent this one.
