Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYKWHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYKWHMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 02:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYKWHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 02:12:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:35426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYKWHMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 02:12:06 -0500
Message-ID: <4929023C.2060302@suse.de>
Date: Sun, 23 Nov 2008 16:11:56 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com, Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Subject: Re: about TRIM/DISCARD support and barriers
References: <4928E010.4090801@kernel.org>
In-Reply-To: <4928E010.4090801@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

cc'ing Matthew whom I forgot to cc in the first message.  Matthew, the
original message is...

 http://lkml.org/lkml/2008/11/22/260

Tejun Heo wrote:
> Dongjun Shin who works for Samsung SSD dep asked me about libata TRIM
> support and pointed me to the new DISCARD support David Woodhouse got
> merged for 2.6.28.  I took a look at the code and blk-layer
> interface-wise we seemed to be ready both for filesystems and userland
> (so that fsck or something which runs background can mark unused
> blocks) but there doesn't seem to be any low level driver which
> actually implements ->prepare_discard_fn or fs which sets the DISCARD
> flag.

Dongjun, the only doc I can find about ATA TRIM is the following one.

 http://t13.org/Documents/UploadedDocuments/docs2007/e07154r3-Data_Set_Management_Proposal_for_ATA-ACS2.pdf

And AFAICS this hasn't made into ACS yet.  Is this what you guys are
gonna implement and Windows7 is gonna use?

Thanks.

-- 
tejun
