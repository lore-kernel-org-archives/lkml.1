Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXFQQ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXFQQ14 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 12:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXFQQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 12:27:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45213 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbXFQQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 12:27:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <467560CF.6090100@s5r6.in-berlin.de>
Date: Sun, 17 Jun 2007 18:26:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de> <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com> <20070617142950.GW3588@stusta.de>
In-Reply-To: <20070617142950.GW3588@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>>> And we should be aware that reverting is only a workaround for the real
>>> problem which lies in our bug handling.
>> ...
> 
> And this is something I want to emphasize again.
> 
> How can we make any progress with the real problem and not only the 
> symptoms?
...

Perhaps make lists of

  - bug reports which never lead to any debug activity
    (no responsible person/team was found, or a seemingly person/team
    did not start to debug the report)

  - known regressions on release,

  - regressions that became known after release,

  - subsystems with notable backlogs of old bugs,

  - other categories?

Select typical cases from each categories, analyze what went wrong in
these cases, and try to identify practicable countermeasures.

Another approach:  Figure out areas where quality is exemplary and try
to draw conclusions for areas where quality is lacking.
-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/
