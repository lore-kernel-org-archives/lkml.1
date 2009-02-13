Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZBMWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZBMWwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 17:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZBMWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 17:52:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZBMWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 17:52:11 -0500
Message-ID: <4995F979.9040304@zytor.com>
Date: Fri, 13 Feb 2009 14:51:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/headers] x86: fix "__udivdi3"	[drivers/scsi/aha1542.ko]
 undefined
References: <tip-bf33a70a73876b163d62612e9567cbac6604ba7e@kernel.org>	 <4995D4A9.5060400@zytor.com> <1234560979.3252.22.camel@localhost.localdomain>
In-Reply-To: <1234560979.3252.22.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-02-13 at 12:14 -0800, H. Peter Anvin wrote:
>> James Bottomley wrote:
>>
>> #define isa_virt_to_bus(x) ((unsigned int)virt_to_phys(x))
>>
>> ... if we're going to do that.
> 
> Actually, it probably wants to become a static inline ... that way the
> compiler can always verify the promotion and truncation is legal
> regardless of whether an actual user is compiled or not.
> 

Yes, that's the right thing to do.  I'll fix it up and commit a patch.

	-hpa

