Return-Path: <linux-kernel-owner+w=401wt.eu-S2993109AbXEBMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993109AbXEBMsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993110AbXEBMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:48:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60984 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993109AbXEBMsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:48:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4638888B.4080908@s5r6.in-berlin.de>
Date: Wed, 02 May 2007 14:48:11 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: [git pull] New firewire stack
References: <4637A29F.6070302@redhat.com> <20070502122147.GA31215@suse.de>
In-Reply-To: <20070502122147.GA31215@suse.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Tue, May 01, Kristian Høgsberg wrote:
> 
>>   drivers/firewire/Kconfig          |   60 ++
> 
> NACK.
> Upgrade the current drivers/ieee1394/ with the new code,

Last time I believe I was the only one who asked whether to put it into
drivers/ieee1394 instead of another directory.  Of course I acknowledge
that everytime a new review round is started, people do reconsider.
Especially since we had a gap of a few months since the last LKML review.

> and keep all existing module names.

I'm impartial to that.  Using same names might ease the transition from
the userspace side, as far as there is userland which relies on module
names.

A certain drawback of same names would be that geeks cannot install both
stacks at once during the transition period.  Therefore, checking
whether eventual problems are in fact regressions involves a module
unload/ configure/ build/ install/ reload cycle, instead of just module
unload/ reload.  This especially means we can only get help from testers
who are able to build kernels.

Other opinions?
-- 
Stefan Richter
-=====-=-=== -=-= ---=-
http://arcgraph.de/sr/
