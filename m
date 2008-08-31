Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYHaPE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYHaPE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 11:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYHaPEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 11:04:47 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54898 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYHaPEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 11:04:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=V7wHjBWkGn8kS1TewcxOQOGP+OkODCV4p8oewn5rl39kK8PTSAiwkrv4xQQUHEZ9CZW2vER9yEo3ifR+yk0hWS3xja4mOOFeUoKny1pbJsk1jlNCkm+BNPrHBvMIT8pS;
Message-ID: <48BAB306.4050207@simon.arlott.org.uk>
Date: Sun, 31 Aug 2008 16:04:38 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
References: <48B9546B.4010004@simon.arlott.org.uk> <1220147947.3615.18.camel@localhost.localdomain> <20080831025412.GJ1239@parisc-linux.org> <200808311625.15655.ioe-lkml@rameria.de>
In-Reply-To: <200808311625.15655.ioe-lkml@rameria.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/08 15:25, Ingo Oeser wrote:
> Hi Matthew,
> 
> On Sunday 31 August 2008, Matthew Wilcox wrote:
>> BTW, I do appreciate Simon's point about df showing a different number.
>> How about we print:
>> 
>> sd 7:0:0:0: [sdc] 1099511627776 512-byte hardware sectors (563TB / 512TiB)
>> 
>> (or perhaps a more realistic number ...)
>> 
>> sd 7:0:0:0: [sdc] 976562500000 512-byte hardware sectors (500TB / 455TiB)
>> 
>> It's perhaps a more gentle way of informing our users that they may not
>> have quite as much capacity as they thought they had.
> 
> Great idea! As a user/admin I would find this the best one of all.
> 
> 1. All variants given.
> 2. Correct scientific units used.

I oppose all the "iB" forms. Has anyone tried pronouncing these?
Pee-bee-bytes?

Alternatively we could just remove the part in brackets from the message...

-- 
Simon Arlott
