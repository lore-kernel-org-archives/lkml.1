Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZDPIlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZDPIlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZDPIkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:40:55 -0400
Received: from relay.atmel.no ([80.232.32.139]:64436 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZDPIky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:40:54 -0400
Date: Thu, 16 Apr 2009 10:40:45 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: Ben Nizette <bn@niasdigital.com>, imre.deak@nokia.com,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
 irq handling on AVR32
Message-ID: <20090416104045.5ff940e2@hskinnemoen-d830>
In-Reply-To: <49E604DB.9070702@billgatliff.com>
References: <1239685153.19815.12.camel@linux-51e8.site>
	<1239698225.29831.14.camel@linux-51e8.site>
	<1239759053.29831.37.camel@linux-51e8.site>
	<20090415095710.5c853a7f@hskinnemoen-d830>
	<20090415103352.5ee43824@hskinnemoen-d830>
	<49E604DB.9070702@billgatliff.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Gatliff wrote:
> Haavard Skinnemoen wrote:
> > AFAICT, this code has always been dangerous.
> >     
> 
> Can you propose a better way to handle the problem?  It's a case that 
> crops up with a lot of touch screen controllers.

I thought I already did: Use disable_irq_nosync() instead.

Haavard
