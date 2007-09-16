Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbXIPJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbXIPJfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 05:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXIPJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 05:35:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37922 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXIPJfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 05:35:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46ECF8C8.5040308@s5r6.in-berlin.de>
Date: Sun, 16 Sep 2007 11:35:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel Machek <pavel@ucw.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty suspend
 stopped working
References: <46EB436E.6030509@googlemail.com>
In-Reply-To: <46EB436E.6030509@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> FireWire

Could you title it "IEEE1394" instead?  (According to the information so
far, it's in drivers/ieee1394, not drivers/firewire.)

> Subject         : empty suspend stopped working around 2.6.23-rc4
> References      : http://lkml.org/lkml/2007/9/11/326
> Last known good : ?
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

I did a quick test on my main test machine, a Mac mini running x86-64
Linux.  Regardless whether swap is on or off and whether ieee1394 and
ohci1394 are loaded or not, it always behaves the same.  It does
something, then ends up with power LED off but a non-blinking cursor,
i.e. _, still shown on the text console.  Is this good or bad?  Note, I
didn't try to resume and won't, because I'm out of spare time.

Perhaps I resurrect two older PCs I have here and set them up for
hibernation sometime during the coming weeks.  But although the words
regression and FireWire meet here, I am so far not inclined to make this
my problem.

Note, the only post-2.6.22 patch to the ieee1394 subsystem which is
directly related to power management went in before 2.6.23-rc1:
"Freezer: make kernel threads nonfreezable by default"
http://me.in-berlin.de/~s5r6/linux1394/merged/in_2.6.23/freezer-make-kernel-threads-nonfreezable-by-default.patch

(Apart from using git, all 2.6.23 patches to ieee1394 and firewire can
be seen at http://me.in-berlin.de/~s5r6/linux1394/merged/in_2.6.23/.)
-- 
Stefan Richter
-=====-=-=== =--= =----
http://arcgraph.de/sr/
