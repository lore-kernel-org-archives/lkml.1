Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbXCSUtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbXCSUtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXCSUtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:49:14 -0400
Received: from www.osadl.org ([213.239.205.134]:36782 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753223AbXCSUtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:49:13 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
	 <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 21:56:16 +0100
Message-Id: <1174337777.13341.621.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 21:35 +0100, Stefan Prechtel wrote:
>            CPU0       CPU1
>  0:      28289          0  local-APIC-edge-fasteio   timer
> ...
> LOC:      28237      28236
> 
> after a read: (I hope that is this what you want :-)
>            CPU0       CPU1
>   0:      30344          0  local-APIC-edge-fasteio   timer
> ...
> LOC:      30292      30291

Is this with AC plugged in ? If yes, please provide the same numbers for
battery mode.

What's the output of 
cat /proc/acpi/processor/C000/power

for 2.6.20 and 2.6.21-rc4-latest-git with and w/o AC ?

Can you also please upload a bootlog with and without AC of 2.6.20 to
bugzilla ?

Thanks,

	tglx


