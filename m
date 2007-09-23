Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXIWSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXIWSdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXIWSdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:33:07 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:60437 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbXIWSdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:33:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=C7H7vhkapR0G4JsY/tTUedDcX0UYAmKRuLW/ZaQmb1EuL9SgGguNRbqV25j+R8P37fytl6Za3BCBRqF8NZeaM04Iko8fPRE0SlO3M/zo8EogpldwZ4fi7S8zcTrLnG2G;
Message-ID: <46F6B15E.7020601@simon.arlott.org.uk>
Date: Sun, 23 Sep 2007 19:33:02 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/3] cxacru: Reduce initialisation delay
References: <46F68708.6070409@simon.arlott.org.uk> <46F6879A.8040408@simon.arlott.org.uk> <200709231823.22957.duncan.sands@math.u-psud.fr>
In-Reply-To: <200709231823.22957.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/07 17:23, Duncan Sands wrote:
> Hi Simon,
> 
>> +	usb_info(usbatm, "started firmware\n");
> ...
>> +		usb_info(usbatm, "loaded config data\n");
> 
> maybe these should be debug messages.  When are they useful?

They are probably only useful as debug messages - although it 
may be desirable to know when the configuration has been set.



Also... it doesn't make sense to load the configuration only 
in heavy_init - if the configuration is changed then there's 
no way in the module to resend it without powering the device 
down and up. Some sysfs parameters to change configuration 
could be useful... except there's no information as to what 
these settings are.

-- 
Simon Arlott
