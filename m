Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbYLDWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbYLDWVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbYLDWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:21:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:56399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508AbYLDWVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:21:06 -0500
Message-ID: <493857B5.8000104@kernel.org>
Date: Thu, 04 Dec 2008 14:20:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost> <20081204123335.GP6703@one.firstfloor.org> <20081204153411.GA18306@elte.hu> <493846E1.7010104@kernel.org> <20081204220919.GU6703@one.firstfloor.org>
In-Reply-To: <20081204220919.GU6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> but smp_found_config is set acpi_boot_init.. with madt.
>>
>> could move that check earlier
> 
> Then it wouldn't print the "Using ACPI foo" messages. I think it's better
> to put it later like my patch did.
> 
> BTW the function could really need splitting up, it seems to do lots
> of unrelated things.

should move those print out to acpi_boot_init(). 

YH
