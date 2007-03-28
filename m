Return-Path: <linux-kernel-owner+w=401wt.eu-S965749AbXC1UPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965749AbXC1UPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965763AbXC1UPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:15:38 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52810 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965757AbXC1UPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:15:13 -0400
Date: Wed, 28 Mar 2007 22:15:11 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Ethan Solomita <solo@google.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [FIXED] Re: tty OOPS (Re: 2.6.21-rc5-mm2)
Message-ID: <20070328201511.GA20889@rhlx01.hs-esslingen.de>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de> <20070328173310.GA4682@rhlx01.hs-esslingen.de> <20070328174524.GA25709@rhlx01.hs-esslingen.de> <20070328180446.GA7528@rhlx01.hs-esslingen.de> <20070328183814.GA5306@martell.zuzino.mipt.ru> <20070328185632.GB5306@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328185632.GB5306@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 28, 2007 at 10:56:32PM +0400, Alexey Dobriyan wrote:
> The only suspicious new patch in -rc5-mm1 to me is
> fix-sysfs-reclaim-crash.patch which removes "sd->s_dentry = NULL;". Note
> that whole sysfs_drop_dentry() is NOP if ->s_dentry is NULL.
> 
> Could you try to revert it?
> 
> 	Alexey, who knows very little about sysfs internals

Apparently that's still too much knowledge ;)

Or, in other words: 6 reboots already and not a single problem!

So yes, the removal of the NULLing line in this patch most likely
has caused this issue on my box.
Now the question is whether something as simple as that is a fully
correct fix or whether something should be done entirely differently.
I'll let people more familiar with those parts decide about it...

Thanks!

Andreas Mohr
