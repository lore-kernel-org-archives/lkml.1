Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXCHJz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXCHJz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXCHJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:55:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44974 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXCHJz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:55:57 -0500
Message-ID: <45EFDD8C.3070702@garzik.org>
Date: Thu, 08 Mar 2007 04:55:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>	<20070305084257.GA4464@mellanox.co.il>	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>	<45ED8A12.5040803@intel.com>	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>	<m1649cdfas.fsf@ebiederm.dsl.xmission.com>	<20070307185317.5601d452.akpm@linux-foundation.org> <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Until I get the best scenario I can come up with is a tg3 hardware bug
> that doesn't renable the pci-X capability after a restore of power state.


Speaking of tg3, make sure you are aware that the number of calls to 
save-state functions may not match the number of calls to the 
restore-state functions.  ISTR seeing some memleak bugs in PCI related 
to this.

	Jeff


