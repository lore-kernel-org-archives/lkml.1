Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZKIMKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZKIMKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZKIMKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:10:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbZKIMKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:10:24 -0500
Date: Mon, 9 Nov 2009 17:39:26 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       virtualization@linux-foundation.org
Subject: Re: [PATCH v10 1/1] virtio_console: Add support for multiple ports
	for generic guest and host communication
Message-ID: <20091109120926.GB11256@amit-x200.redhat.com>
References: <1257266319-24300-1-git-send-email-amit.shah@redhat.com> <1257266319-24300-2-git-send-email-amit.shah@redhat.com> <200911060843.05934.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911060843.05934.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Nov 06 2009 [08:43:05], Christian Borntraeger wrote:
> Am Dienstag 03 November 2009 17:38:39 schrieb Amit Shah:
> 
> > drivers/char/Kconfig           |    6 +
> > drivers/char/virtio_console.c  | 1412 ++++++++++++++++++++++++++++++++++++----
> > include/linux/virtio_console.h |   50 ++-
> > 3 files changed, 1332 insertions(+), 136 deletions(-)
> 
> I have not looked at your last two versions of the patch  since you did not add 
> a changelog to your patch description. I thought you only did minor changes.
> Turned out you added/changed several places. (e.g. VIRTIO_CONSOLE_CACHE_BUFFERS, 
> VIRTIO_CONSOLE_THROTTLE_PORT  and VIRTIO_CONSOLE_BUFFER_LIMIT  are all new)

I see v8 slipped out without a changelog; sorry for that. v9, v10 had
the changelogs but v8 had included the caching and throttling support.

		Amit
