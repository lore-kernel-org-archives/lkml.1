Return-Path: <linux-kernel-owner+w=401wt.eu-S935260AbZDISXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260AbZDISXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbZDISXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:23:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbZDISXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:23:22 -0400
Message-ID: <49DE3CBE.8030607@kernel.org>
Date: Thu, 09 Apr 2009 11:21:50 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       George Spelvin <linux@horizon.com>
Subject: Re: [PATCH libata: add SSD detection hueristic; move SSD setup to
 ata_dev_configure (was Re: [GIT PULL] Ext3 latency fixes)
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <49D8E71F.6000703@rtr.ca> <49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org> <49D99775.9030104@garzik.org> <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain> <49DBAC42.4040003@garzik.org>
In-Reply-To: <49DBAC42.4040003@garzik.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 18:21:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> ata_id_string() or ata_id_c_string() is what you want.
> 
> But yeah, we see what you're trying to illustrate.
> 
> For internal reasons, it is better to detect and set up SSD details in
> ata_dev_configure(), where we detect and configure other ATA details.
> 
> I've attached an example patch, compiled-tested only.
> 
> If we wanted to get more fancy, we could extend the strn_pattern_cmp()
> function in libata to accept wildcard '*' prefixes, as well as suffixes.
>  That would make it easy to auto-configure future ATA devices based on
> the product id (such as "G.SKILL 128GB SSD").

There was an shell globbing patch floating around which would be
pretty nice to have for pattern matchings like this.  cc'ing the patch
author.  George, what happened to the patch?

Thanks.

-- 
tejun
