Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXIZJOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXIZJOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbXIZJOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:14:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbXIZJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:14:40 -0400
Date: Wed, 26 Sep 2007 02:14:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] 2.6.23-rc8-mm1: drivers/kvm/ioapic.o build failure
Message-Id: <20070926021424.37e34b4c.akpm@linux-foundation.org>
In-Reply-To: <46FA1F99.8080701@qumranet.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<200709252256.23478.m.kozlowski@tuxland.pl>
	<46FA1F99.8080701@qumranet.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:00:09 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Mariusz Kozlowski wrote:
> > Hello,
> >
> > 	Similar (the same?) as in 2.6.23-rc6-mm1?
> >
> > http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg208812.html
> > 	
> >   CC [M]  drivers/kvm/ioapic.o
> > drivers/kvm/ioapic.c: In function 'ioapic_deliver':
> > drivers/kvm/ioapic.c:208: error: 'dest_LowestPrio' undeclared (first use in this function)
> > drivers/kvm/ioapic.c:208: error: (Each undeclared identifier is reported only once
> > drivers/kvm/ioapic.c:208: error: for each function it appears in.)
> > drivers/kvm/ioapic.c:219: error: 'dest_Fixed' undeclared (first use in this function)
> > make[2]: *** [drivers/kvm/ioapic.o] Error 1
> > make[1]: *** [drivers/kvm] Error 2
> > make: *** [drivers] Error 2
> >
> >   
> 
> We now include asm/io_apic.h like we should.  Has that file changed in -mm?
> 

CONFIG_X86_IO_APIC isn't set.
