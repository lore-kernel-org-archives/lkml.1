Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYJIC0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYJIC0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJIC0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:26:41 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:33366 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYJIC0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:26:41 -0400
Message-ID: <48ED6BE5.30908@billgatliff.com>
Date: Wed, 08 Oct 2008 21:26:45 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hylands <dhylands@gmail.com>
CC: Remy Bohmer <linux@bohmer.net>, Jon Smirl <jonsmirl@gmail.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Toggling GPIO at 38Khz
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>	<3efb10970810081157s5e0f8034n63856d2da42b3ad3@mail.gmail.com> <c32efac40810081524q15b0a747oe49de0cf0a2aa2e2@mail.gmail.com>
In-Reply-To: <c32efac40810081524q15b0a747oe49de0cf0a2aa2e2@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hylands wrote:

> You could also do something similar if you have a SPI interface. Just
> set the clock to the right frequency and use the bits sent out to
> generate your pulses.

Good point.  I have seen that very thing done before, albeit for something other
than IRDA.  SPI is particularly nice for that, because you don't have to deal
with the start/stop bits imposed by UART protocols.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
