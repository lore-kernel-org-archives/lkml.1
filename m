Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZDTJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZDTJEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 05:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZDTJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 05:04:24 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:58468 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751293AbZDTJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:04:23 -0400
X-BigFish: VPS-42(z971J3dc9i6f5iz154cP1432R98dR14ffO1805M936fKzz1202hzzz32i6bh)
X-FB-SS: 13,
X-WSS-ID: 0KIE6IX-01-PIE-01
Date: Mon, 20 Apr 2009 11:04:00 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
Message-ID: <20090420090400.GC7286@alberich.amd.com>
References: <49E89D1B.7060800@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49E89D1B.7060800@suse.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Apr 2009 09:04:10.0423 (UTC) FILETIME=[F7D92C70:01C9C196]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:15:39AM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi all -
> 
> I saw this while booting 2.6.30-rc1, -rc2, and today's git, on one of
> my development nodes. This output is with apic=debug. With noapic,
> it still hung. Both outputs follow.
> 
> git bisect leads to commit 8d6f0c8214928f7c5083dd54ecb69c5d615b516e,
> but I'm not seeing anything obvious there. Backing just that change
> out doesn't fix it.

It's the next commit c23e253e67c9d8a91a0ffa33c1f571a17f0a2403 that
causes the problems.

On another system I've seen that resetting the HPET_COUNTER did not
take effect. I am going to provide a fix for that but had no time yet
to test this on an affected system.


Regards,
Andreas


