Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYBKQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYBKQ5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYBKQ5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:57:34 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58180 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbYBKQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:57:32 -0500
X-Greylist: delayed 687 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2008 11:57:32 EST
Message-ID: <47B07E76.9000100@tiscali.nl>
Date: Mon, 11 Feb 2008 17:57:26 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: kyle@parisc-linux.org, Matthew Wilcox <matthew@wil.cx>,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]	pcxl_dma_ops.alloc_noncoherent
 = pa11_dma_alloc_consistent?
References: <47B07685.5000606@tiscali.nl> <1202748349.3122.31.camel@localhost.localdomain>
In-Reply-To: <1202748349.3122.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-02-11 at 17:23 +0100, Roel Kluin wrote:
>> duplicate pa11_dma_alloc_consistent; more appropriate appears
>> pa11_dma_alloc_noncoherent here. 
>>
>> Not tested, please confirm that this fix is correct
> 
> No, it looks completely incorrect to me.  What makes you think a pcxl
> box has a problem with coherency?

Ok, please ignore the patch then. It just appeared suspicious to me
that the function did exist, but the names assigned were different.
