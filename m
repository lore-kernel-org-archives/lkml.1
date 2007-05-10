Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbXEJR5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbXEJR5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 13:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbXEJR44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 13:56:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54250 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbXEJR44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 13:56:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46435CC2.2060909@s5r6.in-berlin.de>
Date: Thu, 10 May 2007 19:56:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net,
       Kristian H?gsberg <krh@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Olaf Hering <olh@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Bill Fink <billfink@mindspring.com>
Subject: Re: [git pull] New firewire stack (updated)
References: <4637A29F.6070302@redhat.com> <tkrat.b635518ff171071d@s5r6.in-berlin.de> <20070510173850.GA31826@infradead.org>
In-Reply-To: <20070510173850.GA31826@infradead.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, May 10, 2007 at 07:26:56PM +0200, Stefan Richter wrote:
>>   - The drivers still live in drivers/firewire/, i.e. have not been put
>>     into mainline's drivers/ieee1394/.
> 
> I don't quite like that.  Then again git handles renames pretty nicely
> and I hope we'll just shift the new drivers in place when the old code
> goes away completely to give people a seamless migration.

There were some comments in this and past reviews pro and contra the
directory split.  For me, it was easier to deal with patch handling that
way since the stack went into -mm, but once the stack is in Linus' tree,
my work will probably be easier anyway.
-- 
Stefan Richter
-=====-=-=== -=-= -=-=-
http://arcgraph.de/sr/
