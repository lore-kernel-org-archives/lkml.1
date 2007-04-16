Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbXDPFWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbXDPFWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 01:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXDPFWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 01:22:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:6035 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbXDPFWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 01:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DaF/O+2jj9zCE8yzgRLFGifP41fUOHcYH6huJ4PvKhkjnhcZ3b4gq6solJU27jYdUXT1Ejkf7PDl813upeRt0+/3CB9fVYnUGxouHW17o8BOMYgZvUp7ZZoEnn/u6ZIkZ/3BZlZ/oFKz8oqQKnx4XztFSHZ3XBzxBuqZDSJZCeU=
Message-ID: <46230806.7060908@gmail.com>
Date: Mon, 16 Apr 2007 09:22:14 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org>
In-Reply-To: <4622C462.8020505@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> Mauro,
> 
> I've been out of town for the past few days... I just got home and saw this:
> 
> 
> Mauro Carvalho Chehab wrote:
>>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
>>    - Fix 2/3 for bug 7819: demux and dvr
>>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> I don't think that this is 2.6.21 material.  These patches have not yet
> received
> enough testing to be sent to mainline.
> 
> I have tested them, and they seem to work for my cxusb device, but we have
> yet to hear test results from users of usb dvb devices that do not use the
> dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)
> 
> The bug that these patches fix has been around throughout the entire kernel
> history of the dvb subsystem.  The bug is not a regression -- it has
> always been
> there.  In my opinion, it is too late in 2.6.21 development to apply
> this change.
> Because these fixes are not obvious, I think we should let them get some
> more testing, and have them queued for 2.6.22 .


I am not arguing about the veracity of the patches, but how things are
handled.

Agreed to all the mentioned above. There is one more aspect. The
mentioned patches, do not have any ACK/SOB from any DVB
developer/maintainer for the same.

Huge regressions are created this way. One more time the regression
creator is caught.

Manu
