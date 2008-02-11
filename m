Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYBKPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYBKPhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYBKPhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:37:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33765 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbYBKPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:37:10 -0500
Message-ID: <47B06B9B.1000801@garzik.org>
Date: Mon, 11 Feb 2008 10:36:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Tom Herbert <therbert@google.com>
Subject: Re: [PATCH] forcedeth: seperate handler for msix and normal int.
References: <200712291415.47835.yinghai.lu@sun.com>
In-Reply-To: <200712291415.47835.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] forcedeth: seperate handler for msix and normal int.
> 
> so we don't need to keep checking np->msi_flags to see if NV_MSI_X_ENABLED is set in
> handler
> 
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Two comments:

* can you regenerate this on top of 2.6.25-rc1?

* take a look at the 'fe' branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

and see what you think about the work in there.  We need to get cleanups 
like that (and more) upstream.  It also intersects with Tom @ Google's 
"Reduce locking in TX path" patch.

	Jeff



