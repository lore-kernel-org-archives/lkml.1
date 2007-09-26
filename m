Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXIZJAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXIZJAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXIZJAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:00:31 -0400
Received: from il.qumranet.com ([82.166.9.18]:43685 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbXIZJAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:00:30 -0400
Message-ID: <46FA1F99.8080701@qumranet.com>
Date: Wed, 26 Sep 2007 11:00:09 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] 2.6.23-rc8-mm1: drivers/kvm/ioapic.o build failure
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <200709252256.23478.m.kozlowski@tuxland.pl>
In-Reply-To: <200709252256.23478.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello,
>
> 	Similar (the same?) as in 2.6.23-rc6-mm1?
>
> http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg208812.html
> 	
>   CC [M]  drivers/kvm/ioapic.o
> drivers/kvm/ioapic.c: In function 'ioapic_deliver':
> drivers/kvm/ioapic.c:208: error: 'dest_LowestPrio' undeclared (first use in this function)
> drivers/kvm/ioapic.c:208: error: (Each undeclared identifier is reported only once
> drivers/kvm/ioapic.c:208: error: for each function it appears in.)
> drivers/kvm/ioapic.c:219: error: 'dest_Fixed' undeclared (first use in this function)
> make[2]: *** [drivers/kvm/ioapic.o] Error 1
> make[1]: *** [drivers/kvm] Error 2
> make: *** [drivers] Error 2
>
>   

We now include asm/io_apic.h like we should.  Has that file changed in -mm?

-- 
error compiling committee.c: too many arguments to function

