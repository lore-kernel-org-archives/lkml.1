Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbXIKBIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbXIKBIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 21:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXIKBIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 21:08:12 -0400
Received: from [218.94.60.124] ([218.94.60.124]:45205 "EHLO
	nj-server.nj.cpsecure.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759606AbXIKBIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 21:08:12 -0400
X-CSG-FAST-BLOCK: Enabled
Message-ID: <46E5EAA1.3030302@nj.cpsecure.com>
Date: Tue, 11 Sep 2007 09:08:49 +0800
From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Reply-To: Dong_Wei@nj.cpsecure.com
Organization: CPsecure Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dynamically use the irqbalance
References: <46E4A51D.2050804@nj.cpsecure.com> <20070910160921.5f8e2d73@laptopd505.fenrus.org>
In-Reply-To: <20070910160921.5f8e2d73@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




> On Mon, 10 Sep 2007 09:59:57 +0800
> Dong_Wei <Dong_Wei@nj.cpsecure.com> wrote:
> 
>> Hi, all.
>>    I want to dynamically use irqbalance on X86 processor. My design
>> is like the following:
>>    1) if we boot kernel with "noirqbalance", then irqbalance is
>> always disabled.
>>    2) if we boot kernel without "noirqbalance", we can enable/disable 
>> irqbalance in runtime.
> 
> Hi,
> 
> kernel level irqbalance is not the right thing though (afaik it's in
> feature-deprecation-schedule); please consider using the userland
> irqbalancer instead (www.irqbalance.org). That also makes it entirely
> easy to do what you want; since it's a daemon, starting and stopping it
> follows standard Linux practice.

OK, I see. Maybe it's safe for me to run irqbalance using the userland.
Thanks a lot Arjan:)

> Greetings,
>     Arjan van de Ven



