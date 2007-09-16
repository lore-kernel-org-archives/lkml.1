Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXIPKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXIPKYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 06:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXIPKYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 06:24:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38892 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXIPKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 06:24:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46ED0418.3020709@s5r6.in-berlin.de>
Date: Sun, 16 Sep 2007 12:23:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ben Collins <ben.collins@ubuntu.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty	suspend
 stopped working
References: <46EB436E.6030509@googlemail.com>	<46ECF8C8.5040308@s5r6.in-berlin.de> <20070916024159.c067dc1a.akpm@linux-foundation.org>
In-Reply-To: <20070916024159.c067dc1a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 16 Sep 2007 11:35:04 +0200 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Regardless whether swap is on or off and whether ieee1394 and
>> ohci1394 are loaded or not, it always behaves the same.  It does
>> something, then ends up with power LED off but a non-blinking cursor,
>> i.e. _, still shown on the text console.
...
> When it is in this state, try hitting a key lots of times.  It Works For Me ;)

Doesn't work here.

> Try Thomas's hrt tree, below.  It Also Works For Me.

No change with this either.
-- 
Stefan Richter
-=====-=-=== =--= =----
http://arcgraph.de/sr/
