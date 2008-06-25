Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYFYTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYFYTXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYFYTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:23:09 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:3386 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYFYTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:23:08 -0400
X-IronPort-AV: E=Sophos;i="4.27,703,1204502400"; 
   d="scan'208";a="758649"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Wed, 25 Jun 2008 20:22:58 +0100
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Stephen Tweedie <sct@redhat.com>
Message-ID: <C48859A2.231C5%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork
 for 64-bit Xen support
Thread-Index: AcjW+OAYHmuW1kLsEd2ISwAX8io7RQ==
In-Reply-To: <20080625191315.GD6708@one.firstfloor.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2008 19:23:07.0504 (UTC) FILETIME=[E5C2C700:01C8D6F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/6/08 20:13, "Andi Kleen" <andi@firstfloor.org> wrote:

>> What does Linux expect to scale up to? Reserving 16 PML4 entries leaves the
>> kernel with 120TB of available 'negative' address space. Should be plenty, I
>> would think.
> 
> There are already (ok non x86-64) systems shipping today with 10+TB of
> addressable memory. 100+TB is not that far away with typical
> growth rates. Besides there has to be much more in the negative address
> space than just direct mapping.

There are obviously no x64 boxes around at the moment with >1TB of regular
shared memory, since no CPUs have more than 40 address lines. 100+TB RAM is
surely years away.

If this is a blocker issue, we could just keep PAGE_OFFSET as it is when Xen
support is not configured into the kernel. Then those who are concerned
about 5% extra headroom at 100TB RAM sizes can configure their kernel
appropriately.

> So far we always that 64bit Linux can support upto 1/4*max VA memory.
> With your change that formula would be not true anymore.

Does the formula have any practical significance?

 -- Keir


