Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZDTI70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZDTI70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZDTI7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:59:17 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:3700 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751562AbZDTI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:59:16 -0400
X-BigFish: VPS-45(z971J3dc9i6f5iz154cP1432R98dR14ffO4015M1805M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIE6AG-02-FDO-01
Date: Mon, 20 Apr 2009 10:58:54 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
Message-ID: <20090420085854.GB7286@alberich.amd.com>
References: <49E89D1B.7060800@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <49E89D1B.7060800@suse.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Apr 2009 08:59:03.0949 (UTC) FILETIME=[412CF3D0:01C9C196]
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
> 
> - -Jeff

This looks similar to http://bugzilla.kernel.org/show_bug.cgi?id=12961

Can you please provide lspci -nnxxx and dmesg when booting with hpet=verbose.

Thanks,

Andreas


