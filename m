Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXIZCeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXIZCeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXIZCdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:33:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56266 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbXIZCdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:33:51 -0400
Message-ID: <46F9C50A.2080009@garzik.org>
Date: Tue, 25 Sep 2007 22:33:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com> <46F9B3FE.1060905@garzik.org> <46F9C336.3010005@gmail.com>
In-Reply-To: <46F9C336.3010005@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Berck E. Nash wrote:
> Jeff Garzik wrote:
>> Does the attached patch change behavior at all?  You should be able to
>> apply it on top of libata-dev.git#upstream or -mm.
> 
> Still broken, dmesg with ATA_DEBUG defined, attached.

Great, this will be useful output.  It will probably be a couple days 
before my next patch.  In the meantime, you can extract the bad commit 
to a patch

	git-diff-tree -p 268fe6f9f15551be9abedd44a237392675d529d5 > \
		/tmp/patch

and then revert it locally in your kernel tree

	patch -sp1 -R < /tmp/patch

to temporarily work around this.

I will definitely make sure this is either fixed or reverted before it 
goes upstream to Linus.

Thanks,

	Jeff


