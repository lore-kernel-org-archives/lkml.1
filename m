Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYBLWNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYBLWNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYBLWNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:13:34 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54429 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302AbYBLWNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:13:33 -0500
Date: Tue, 12 Feb 2008 23:13:30 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
       Shannon Nelson <shannon.nelson@intel.com>,
       David Brownell <david-b@pacbell.net>, kernel@avr32linux.org,
       Francis Moreau <francis.moro@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "Vladimir A. Barinov" <vbarinov@ru.mvista.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [RFC v3 5/7] dmaengine: Make DMA Engine menu visible for AVR32
 users
Message-ID: <20080212231330.79738c3a@siona>
In-Reply-To: <20080212204330.GA3184@lixom.net>
References: <1202834638-9009-1-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-2-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-3-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-4-git-send-email-hskinnemoen@atmel.com>
	<1202834638-9009-5-git-send-email-hskinnemoen@atmel.com>
	<20080212204330.GA3184@lixom.net>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 14:43:30 -0600
Olof Johansson <olof@lixom.net> wrote:

> > -	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
> > +	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || AVR32  
> 
> This is a slippery slope. Things should be the other way around instead,
> create a HAVE_DMA_DEVICE, select it in the relevant platform code and
> make DMADEVICES depend on that.

Agree. I'll cook up a patch tomorrow to make it use the new HAVE_*
scheme.

> Or just let the subsystem always be available.

It used to be always available, but then it was changed. Assuming there
was a reason for this change, I guess we don't want to change it back.

Haavard
