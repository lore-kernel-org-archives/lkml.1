Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXLTUkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXLTUkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXLTUkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:40:08 -0500
Received: from smtp.galliera.it ([62.101.86.54]:36664 "EHLO smtp.galliera.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbXLTUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:40:06 -0500
X-Greylist: delayed 1165 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 15:40:05 EST
Date: Thu, 20 Dec 2007 21:19:01 +0100
From: Emanuele Rocca <ema@linux.it>
To: David Miller <davem@davemloft.net>
Cc: stefanr@s5r6.in-berlin.de, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, krh@bitplanet.net,
       linux1394-devel@lists.sourceforge.net
Subject: Re:  No dma_sync_* during pci_probe? (Sparc, post 2.6.22
	regression)
Message-ID: <20071220201901.GA30969@darkmoon.home>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	stefanr@s5r6.in-berlin.de, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@suse.de, krh@bitplanet.net,
	linux1394-devel@lists.sourceforge.net
References: <4767A323.7090205@s5r6.in-berlin.de> <20071218.142956.26529678.davem@davemloft.net> <476947C1.2010405@s5r6.in-berlin.de> <20071220.004033.75315225.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220.004033.75315225.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net>, [2007-12-20  0:40 -0800]:
>  The problem is that I created indirection that was totally unused, the
>  operation vectors members for these cases thus didn't get filled in,
>  and we OOPS trying to call NULL pointers as functions :-)
>  
>  This should fix the crash:

It does, tested on a Sun Blade 2000.

Thank you David.
ciao,
    ema
