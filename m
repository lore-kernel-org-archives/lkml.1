Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYKPP3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYKPP3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYKPP33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:29:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:43214 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbYKPP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:29:29 -0500
Message-ID: <49203C63.4070803@kernel.org>
Date: Mon, 17 Nov 2008 00:29:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: WARN_ON(ap->nr_active_links) in ata_eh_finish() with
 pata_ali DMA CD-ROM
References: <200811042128.10356.arvidjaar@mail.ru> <49194B8F.80104@kernel.org> <200811161559.08981.arvidjaar@mail.ru>
In-Reply-To: <200811161559.08981.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Nov 2008 15:29:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrey Borzenkov wrote:
> On Tuesday 11 November 2008, Tejun Heo wrote:
>> Andrey Borzenkov wrote:
> rc5 is the first release ever that correctly falls back to PIO from DMA
> on ATAPI connected to pata_ali. Wow! Thank you!

Hmm... this should have worked on 2.6.27 too.  How did it fail on
2.6.27?

pata_ali ATAPI dma problem is sad.  I have the hardware and the ide
driver works fine and I still can't figure out what's wrong.  :-(

-- 
tejun
