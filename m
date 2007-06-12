Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbXFLRCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbXFLRCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXFLRCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:02:35 -0400
Received: from mail.tmr.com ([64.65.253.246]:45293 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbXFLRCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:02:34 -0400
Message-ID: <466ED22E.8050506@tmr.com>
Date: Tue, 12 Jun 2007 13:04:46 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mike Accetta <maccetta@laurelnetworks.com>, stable@kernel.org
Subject: Re: [PATCH 000 of 2] md: Introduction - bugfixes for md/raid{1,10}
References: <20070612110634.25171.patches@notabene>
In-Reply-To: <20070612110634.25171.patches@notabene>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> Following are a couple of bugfixes for raid10 and raid1.  They only
> affect fairly uncommon configurations (more than 2 mirrors) and can
> cause data corruption.  Thay are suitable for 2.6.22 and 21-stable.
>
> Thanks,
> NeilBrown
>
>
>  [PATCH 001 of 2] md: Fix two raid10 bugs.
>  [PATCH 002 of 2] md: Fix bug in error handling during raid1 repair.

I don't know about uncommon, given that I have six machines in this 
building with three way RAID-1 for the boot partition, to be sure I can 
get off the ground enough to get the other partitions up.

And since you added "write-mostly" for remote mirrors I do have a few 
systems doing >2 mirrors as well. This set of patches definitely will be 
in my kernel by this afternoon.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

