Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZDNIhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZDNIhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZDNIhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:37:32 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:24479
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbZDNIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:37:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkYCAAro40l8qNo9/2dsb2JhbAAIziKDfAY
X-IronPort-AV: E=Sophos;i="4.40,183,1238947200"; 
   d="scan'208";a="418189858"
Subject: Re: [REGRESSION] threaded interrupt handler support breaks (some)
	irq handling on AVR32
From: Ben Nizette <bn@niasdigital.com>
To: tglx@linutronix.de
Cc: mingo@elte.hu, hskinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, imre.deak@nokia.com,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <1239685153.19815.12.camel@linux-51e8.site>
References: <1239685153.19815.12.camel@linux-51e8.site>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 18:37:05 +1000
Message-Id: <1239698225.29831.14.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 14:59 +1000, Ben Nizette wrote:

> Note it's that very last line which, when triggered, causes the hang.
> As you can see, it's the only one connected through the gpio interrupt
> chip.

Okhayy..  This is probably a red herring.  I just connected a button to
a gpio irq on that board and it sat there happily interrupting all night
long.

If anyone's reading with an ADS7846 on some other arch can they try to
reproduce?

If no one beats me to it i'll try and scatter printks and narrow down
exactly *where* it all explodes tomorrow.

Thx,
	--Ben.

