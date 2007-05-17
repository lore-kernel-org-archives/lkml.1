Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbXEQTxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbXEQTxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXEQTxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:53:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41706 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXEQTx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:53:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <464CB2B3.50506@s5r6.in-berlin.de>
Date: Thu, 17 May 2007 21:53:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: lkml@dervishd.net
CC: linux-kernel@vger.kernel.org
Subject: Re: usb-storage nice value
References: <20070517100308.GA14667@DervishD>
In-Reply-To: <20070517100308.GA14667@DervishD>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD wrote:
>     I'm having problems when reading/writing to external USB harddisks:
> my *internal* harddisk stalls from time to time, so watching a movie
> while copying data is a PITA (well, if the movie is bad, the leaps help
> a bit...).

If the internal harddisk is source or target of these copy operations...

...
> is there any way of modifying the pdflush behaviour so
> large buffered writes are less "agressive" and doesn't block apps which
> are just reading?

...then switching to another IO scheduler might perhaps help.

# cat /sys/block/hda/queue/scheduler

# echo deadline > /sys/block/hda/queue/scheduler
-- 
Stefan Richter
-=====-=-=== -=-= =---=
http://arcgraph.de/sr/
