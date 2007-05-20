Return-Path: <linux-kernel-owner+w=401wt.eu-S1762513AbXETIca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762513AbXETIca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 04:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbXETIcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 04:32:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbXETIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 04:32:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4650074A.6000307@s5r6.in-berlin.de>
Date: Sun, 20 May 2007 10:31:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <20070519110944.2a52061e.akpm@linux-foundation.org>	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>	 <464F9A7B.1030708@s5r6.in-berlin.de>	 <a781481a0705191753r25e0cay82785ed56c04b6eb@mail.gmail.com> <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
In-Reply-To: <a781481a0705191804u7f5a344cr92f2a1981c502bf7@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> You'll learn about the "default .. if .." Kconfig idiom after you try
> this,

I have seen these in the rest of the patch which I didn't quote.

However you fix it --- don't remove "depends on" or "select".  You can
interchange them, but not remove them, unless there wasn't a dependency
to begin with.

Games with default values will break the next time a genius patch
submitter comes around with his ideas how people configure kernels.

PS:  I still believe that the saner approach would be to carry only the
dependencies, prompt texts and help texts in Kconfig files, maybe
amended by new machine-readable markers regarding the role of an option.
The presentation and ways to select and deselect should be entirely left
to UIs.
-- 
Stefan Richter
-=====-=-=== -=-= =-=--
http://arcgraph.de/sr/
