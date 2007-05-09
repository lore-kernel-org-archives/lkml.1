Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbXEISu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbXEISu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXEISuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 14:50:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45740 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXEISuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 14:50:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46421762.8020208@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 20:48:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ego@in.ibm.com, Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, James.Bottomley@steeleye.com,
       aneesh.kumar@gmail.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       greg@kroah.com, mingo@elte.hu, neilb@suse.de, oleg@tv-sign.ru,
       paulmck@linux.vnet.ibm.com, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel
 threads
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641CAAF.8060103@s5r6.in-berlin.de> <20070509152913.GA16090@in.ibm.com> <200705092018.17116.rjw@sisk.pl>
In-Reply-To: <200705092018.17116.rjw@sisk.pl>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 9 May 2007 17:29, Gautham R Shenoy wrote:
>> On Wed, May 09, 2007 at 03:20:47PM +0200, Stefan Richter wrote:
>>> Let me point out that the usual process would be
[...to do it in one go....]
>> Well, a couple of RFC's have already been sent with this regard.
>> Most of these recent freezer changes resulted due to the discussions
>> that took place over  these RFC's.
[...]
> I feel I ought to explain why it's ended up in this state.
> 
> This is not a new patch.  It's been in -mm since 2.6.21-rc2-mm1 (at least)
> and we hoped to have the selective freezing of the system for different events
> done before the 2.6.22 merging window would open.  It didn't happen, mainly
> for reasons that we couldn't control, and now we have some patches that
> depend on this one and are more urgent, since they're needed to fix some bugs.

OK, thanks once more for the explanations.

[...]
>> Will keep you posted on the freezer developments from now on.
> 
> Me too.

Well, the mistake on my part was that I didn't pull -mm regularly,
otherwise I would have automatically seen the change to the one kthread
I am interested in.

Thanks,
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
