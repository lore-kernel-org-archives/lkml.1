Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYDPBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYDPBMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYDPBML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 21:12:11 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:48410 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYDPBMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 21:12:10 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: ata2: SATA link down (SStatus 611 SControl 300)
References: <87od8cxg45.fsf@burly.wgtn.ondioline.org>
	<48040AB5.6050300@gmail.com> <87hce3yhmi.fsf@burly.wgtn.ondioline.org>
	<480419B6.1050309@gmail.com> <87d4oryf4u.fsf@burly.wgtn.ondioline.org>
	<4804288D.5090504@gmail.com> <87y77ex1oh.fsf@burly.wgtn.ondioline.org>
	<48052BB3.2090509@gmail.com> <87od8awxh5.fsf@burly.wgtn.ondioline.org>
	<48054515.4020202@gmail.com> <4805496E.7000306@gmail.com>
Date: Wed, 16 Apr 2008 13:06:13 +1200
In-Reply-To: <4805496E.7000306@gmail.com> (Tejun Heo's message of "Wed, 16 Apr
	2008 09:33:50 +0900")
Message-ID: <87k5iywquy.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:

>> Thanks for checking.  Yeah, on the second though, ata_piix as of
>> 2.6.24.3 doesn't have SCR access at all, so it would have just
>> worked. Maybe what's necessary is more refined link onlineness test.
>> I'll prep a patch.
>
> Can you please try the attached patch?  Thanks.

Works nicely.

  ata2: link in slumber mode, forcing hardreset
  ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata2.01: NODEV after polling detection
  ata2.00: ATAPI: HL-DT-ST RW/DVD GCC-H10N, 1.03, max UDMA/100
  ata2.00: configured for UDMA/100

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
