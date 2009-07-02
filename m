Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZGBMSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZGBMSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZGBMSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:18:34 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.106]:13408
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbZGBMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:18:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkBAN9BTEp8qMex/2dsb2JhbAAIzzWEEQWBOg
X-IronPort-AV: E=Sophos;i="4.42,333,1243785600"; 
   d="scan'208";a="545668119"
Subject: Re: [PATCH] MMC Core: Drop initialization frequency floor to 50kHz
From: Ben Nizette <bn@niasdigital.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: pierre@ossman.eu, s.hauer@pengutronix.de, kernel <kernel@avr32linux.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090702135849.21370282@hskinnemoen-d830>
References: <1246492196.2980.17.camel@linux-51e8.site>
	 <20090702135849.21370282@hskinnemoen-d830>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 22:17:36 +1000
Message-Id: <1246537056.2980.60.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 13:58 +0200, Haavard Skinnemoen wrote:
> Ben Nizette wrote:
> > Was recently merged.  This is too fast for at least one setup
> > permutation - the one on my desk which through trial and error won't
> > initialise at anything above ~350kHz (older Sandisk 256MB SD on
> > atmel-mci).
> 
> What kind of board is this? It sounds a bit like the CMD or DATA0
> pull-up is too weak...

It is a custom board (you'll see the board support soon) but those
pullups are 47k same as NGW100 and STK1000.

'scope confirms all the waveforms are crisp and correct.

> 
> Haavard

