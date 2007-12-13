Return-Path: <linux-kernel-owner+w=401wt.eu-S1763767AbXLMSxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763767AbXLMSxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbXLMSx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:53:28 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:49717 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758783AbXLMSx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:53:27 -0500
Date: Thu, 13 Dec 2007 11:53:26 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: QUEUE_FLAG_CLUSTER: not working in 2.6.24 ?
Message-ID: <20071213185326.GQ26334@parisc-linux.org>
References: <47617B92.6020908@rtr.ca> <47617C07.3020501@rtr.ca> <47617E72.6080504@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47617E72.6080504@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 01:48:18PM -0500, Mark Lord wrote:
> Problem confirmed.  2.6.23.8 regularly generates segments up to 64KB for 
> libata,
> but 2.6.24 uses only 4KB segments and a *few* 8KB segments.

Just a suspicion ... could this be slab vs slub?  ie check your configs
are the same / similar between the two kernels.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
