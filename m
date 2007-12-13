Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbXLMUSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbXLMUSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbXLMUSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:18:14 -0500
Received: from rtr.ca ([76.10.145.34]:3171 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826AbXLMUSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:18:13 -0500
Message-ID: <47619383.3050508@rtr.ca>
Date: Thu, 13 Dec 2007 15:18:11 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Matthew Wilcox <matthew@wil.cx>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
References: <20071213185326.GQ26334@parisc-linux.org> <4761821F.3050602@rtr.ca> <20071213192633.GD10104@kernel.dk> <4761883A.7050908@rtr.ca> <476188C4.9030802@rtr.ca> <20071213193937.GG10104@kernel.dk> <47618B0B.8020203@rtr.ca> <20071213195350.GH10104@kernel.dk> <20071213200219.GI10104@kernel.dk> <476190BE.9010405@rtr.ca> <20071213200958.GK10104@kernel.dk> <476192BF.5050308@rtr.ca>
In-Reply-To: <476192BF.5050308@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jens Axboe wrote:
..
>> OK, it's a vm issue, I have tens of thousand "backward" pages after a
>> boot - IOW, bvec->bv_page is the page before bvprv->bv_page, not
>> reverse. So it looks like that bug got reintroduced.
> ...
> 
> Mmm.. shouldn't one of the front- or back- merge logics work for either order?
..

Belay that thought.  I'm slowly remembering how this is supposed to work now.  :)
