Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYFXCXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYFXCXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYFXCXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:23:06 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62288 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYFXCXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:23:03 -0400
Date: Mon, 23 Jun 2008 20:20:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] x86 supports NO_IRQ convention
In-reply-to: <fa.EDfpY1oxab2UaliWrUY0jyr5T1k@ifi.uio.no>
To: David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
Message-id: <486059F9.6060901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.mcHAIQmpGZB1Vrm7ZD4/q9eo08Y@ifi.uio.no>
 <fa.E+RvbN2EFmsI1cxQ84PIB8FbX50@ifi.uio.no>
 <fa.EDfpY1oxab2UaliWrUY0jyr5T1k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 23 June 2008, Benjamin Herrenschmidt wrote:
>> NO_IRQ on x86 is 0
> 
> There is no such #define for it.
> And since zero is used for timer IRQs, it's not invalid.

As far as drivers are concerned it is. IRQ 0 is only used by 
architecture-specific code and is not sharable, so drivers need not be 
concerned about it.
