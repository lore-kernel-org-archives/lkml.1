Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYHaOk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYHaOk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYHaOkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:40:10 -0400
Received: from smtprelay11.ispgateway.de ([80.67.29.28]:49726 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYHaOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:40:09 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
Date: Sun, 31 Aug 2008 16:25:14 +0200
User-Agent: KMail/1.9.10
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-scsi" <linux-scsi@vger.kernel.org>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain> <20080831025412.GJ1239@parisc-linux.org>
In-Reply-To: <20080831025412.GJ1239@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311625.15655.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Sunday 31 August 2008, Matthew Wilcox wrote:
> BTW, I do appreciate Simon's point about df showing a different number.
> How about we print:
> 
> sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (563TB / 512TiB)
> 
> (or perhaps a more realistic number ...)
> 
> sd 7:0:0:0: [sdc] 976562500000 512-byte hardware sectors (500TB / 455TiB)
> 
> It's perhaps a more gentle way of informing our users that they may not
> have quite as much capacity as they thought they had.

Great idea! As a user/admin I would find this the best one of all.

1. All variants given.
2. Correct scientific units used.

I would ACK that one, if you provide a small helper for that printout
somehwere in block/{genhd,blk-core}.c


Best Regards

Ingo Oeser
