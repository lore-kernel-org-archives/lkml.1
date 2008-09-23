Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYIWBrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYIWBrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYIWBrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:47:04 -0400
Received: from mail.sv1.nifty.com ([220.209.183.60]:26534 "EHLO
	defg301p.nifty.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753864AbYIWBrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:47:03 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 21:47:03 EDT
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:content-transfer-encoding;
	b=nqKCucqZ2Vn6KsFo1PL0GLAkHRZJpbGzMaX1Bbv7aVSBpMDPIcR2i57R26ROc+7Gw
	h2Dr30nR9T/w9ApYq6LFw==
X-Nifty-SrcIP: [220.145.29.36]
Date: Tue, 23 Sep 2008 10:31:43 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, torvalds@osdl.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcmcia: Fix broken abuse of dev->driver_data
Message-Id: <20080923103143.4986f85a.komurojun-mbn@nifty.com>
In-Reply-To: <20080923001534.13031535@lxorguk.ukuu.org.uk>
References: <20080922155814.2bdad40f@lxorguk.ukuu.org.uk>
	<20080922215617.GA13057@comet.dominikbrodowski.net>
	<20080922231227.2625dd09@lxorguk.ukuu.org.uk>
	<20080922222655.GA3792@isilmar.linta.de>
	<20080923001534.13031535@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>PCMCIA abuses dev->private_data in the probe methods. Unfortunately it
>continues to abuse it after calling drv->probe() which leads to crashes and
>other nasties (such as bogus probes of multifunction devices) giving errors like
>
>pcmcia: registering new device pcmcia0.1
>kernel: 0.1: GetNextTuple: No more items

The pata_pcmcia works now. Thanks!



Best Regards
Komuro
