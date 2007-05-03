Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXECNba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXECNba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXECNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:31:30 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38644 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXECNb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:31:29 -0400
Message-ID: <4639E3FC.8060107@s5r6.in-berlin.de>
Date: Thu, 03 May 2007 15:30:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux1394-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       krh@redhat.com, Adrian Bunk <bunk@stusta.de>
Subject: Re: [git pull] New firewire stack
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au> <46399BDE.4040605@s5r6.in-berlin.de> <20070503114854.GA12731@suse.de>
In-Reply-To: <20070503114854.GA12731@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Thu, May 03, Stefan Richter wrote:
> 
>> 	ieee1394-old
> 
> Noone will seriously ship two firewire stacks, so that cant be the
> issue (for distributors). 

I don't actively watch distributions, but I believe there are frequently
alternative drivers shipped.  How much sense that makes for FireWire is
another question.

> Once there is a way to easily switch between kernel releases, I'm ok
> with whatever module names you pick. 

It may actually be easier to let problem reporters (who cannot or don't
want to compile kernels) compare between different kernel releases,
rather than to ask them to compare between different stacks on top of
the same kernel.  Still, it potentially reduces the testers base.

Adrian wrote:
| An advantage of changing the names is that they are now prefixed.

Is the opportunity to clean up module names compelling enough, vs. (the
wish for) minimized trouble with scripts which refer to module names?

Kristian wrote:
| Another point in favour of different module names is that the new
| stack doesn't actually provide the same user space interfaces as the
| old stack.

This applies mostly to <fw-core> vs. <ieee1394 + raw1394 + video1394 +
dv1394>.  The rest should look identical to the user, except that some
inapplicable module parameters (and bugs) were removed.
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
