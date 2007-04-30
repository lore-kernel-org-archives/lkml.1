Return-Path: <linux-kernel-owner+w=401wt.eu-S1946876AbXD3W7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946876AbXD3W7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946880AbXD3W7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:59:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:57684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946876AbXD3W7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:59:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Z4b+iEvsPAwxznwhbh5G9ybfAO3Bm1+ayCY4OaBv6ngeKEKtxiDKSryf9hOJwuuYU48vCF7RsliEfD/EVjDPo2bHZFbl6dAm2BUfEDxqCWMk+YTsTUblpNZay2ESPlj9xym1W+uj4Sn6VD5JAT5QG7wgG0DfPAfF/K7L6zdT2io=
Message-ID: <463674A9.9040100@gmail.com>
Date: Tue, 01 May 2007 02:58:49 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and	pseudo-authorities
References: <20070429182209.267430@gmx.net> 	<alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org> 	<20070429205925.129920@gmx.net>	<alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>	<20070429230037.95120@gmx.net>  <1177894713.3046.5.camel@p	<alpine.LFD.0.98.0704300854090.9964@woody.linux-foundation.org> <Pine.LNX.4.58.0704301458460.315@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0704301458460.315@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:

> The issue with dst is just a minor missing feature to fully support the dvb
> helper module customization system.  So nobody needs to worry about this
> anymore, the last two patches in this repository will fix it correctly.

With regards to the dst, i have explained earlier to you that

1) the dst is not a frontend
2) i do not wish to use the frontend attach methods with regards to
dst/dst_ca

To mention, we had these discussions much long back how to go about it
and don't think that every time a new developer get's an account with
linuxtv.org, this has to be a matter that has to discussed to death

http://article.gmane.org/gmane.linux.drivers.dvb/16156/match=patch+dvb+bt8xx+cleanup

(eventhough of not much concern) If you now see most of the code in
dvb-bt8xx especially the DMA stuff was refactored from the dst driver.

But that said, the dst *is* different, so WTH ?
