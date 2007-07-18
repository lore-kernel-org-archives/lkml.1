Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbXGRIQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbXGRIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbXGRIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:16:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53784 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbXGRIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:16:13 -0400
Message-ID: <469DCC4A.9010001@garzik.org>
Date: Wed, 18 Jul 2007 04:16:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] drivers/base/core: improve device_add() error handling,
 fix bugs
References: <20070718055348.GA5734@havoc.gtf.org> <20070718101501.6af017bc@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718101501.6af017bc@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Wed, 18 Jul 2007 01:53:48 -0400,
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> The following change was checked into 'warnings' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
>>
>> commit 5330916f5a11d8b7def46a6b3e14a831684032f5
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Wed Jul 18 01:41:29 2007 -0400
>>
>>     drivers/base/core: improve device_add() error handling, fix bugs
>>     
>>     * silence several warnings by handling sysfs_create_link() failure
>>     
>>     * re-order some operations in error handling, to precisely reverse
>>       the order of operations, i.e. unwind properly.
>>     
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>>  drivers/base/core.c |   46 ++++++++++++++++++++++++++++++----------------
>>  1 file changed, 30 insertions(+), 16 deletions(-)
> 
> Hm, what about driver-core-check-return-code-of-sysfs_create_link.patch
> (merged with ...-fix.patch) which has been in -mm for a while?

No idea, I didn't check there.   If someone else has a better patch... 
great!  Let's merge it :)

	Jeff



