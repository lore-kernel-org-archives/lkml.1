Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYBMIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYBMIo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYBMIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:44:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60288 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753120AbYBMIoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:44:18 -0500
Date: Wed, 13 Feb 2008 09:44:03 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Olof Johansson" <olof@lixom.net>, linux-kernel@vger.kernel.org,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       "David Brownell" <david-b@pacbell.net>, kernel@avr32linux.org,
       "Francis Moreau" <francis.moro@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       "Pierre Ossman" <drzeus-list@drzeus.cx>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [RFC v3 5/7] dmaengine: Make DMA Engine menu visible for AVR32
 users
Message-ID: <20080213094403.1d6ebe8c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <e9c3a7c20802121427v2f3aed68h68bfc12bbce19d19@mail.gmail.com>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
	<20080212204330.GA3184@lixom.net>
	<20080212231330.79738c3a@siona>
	<e9c3a7c20802121427v2f3aed68h68bfc12bbce19d19@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 15:27:29 -0700
"Dan Williams" <dan.j.williams@intel.com> wrote:

> > > Or just let the subsystem always be available.  
> >
> > It used to be always available, but then it was changed. Assuming there
> > was a reason for this change, I guess we don't want to change it back.
> >  
> 
> Adrian had concerns about users enabling NET_DMA when the hardware
> capability is relatively rare.  So, +1 for HAVE_DMA_DEVICE

Why not introduce a new hidden symbol, e.g. DMA_ENGINE_DRIVER, have all
the drivers select it and let NET_DMA depend on it?

Wait a minute...the Kconfig already does this. What was the problem again?

Haavard
