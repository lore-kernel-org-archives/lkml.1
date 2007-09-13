Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXIMECb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXIMECb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXIMECX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:02:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40657 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbXIMECX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:02:23 -0400
Message-ID: <46E8B64D.3030107@garzik.org>
Date: Thu, 13 Sep 2007 00:02:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] usb: fix unterminated usn_device_id lists
References: <20070913004709.GL8183@outflux.net> <46E88F1B.5050405@garzik.org> <20070913035407.GN8183@outflux.net>
In-Reply-To: <20070913035407.GN8183@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> Hi,
> 
> On Wed, Sep 12, 2007 at 09:15:07PM -0400, Jeff Garzik wrote:
>>> +	{ 0, },
>> FWIW I (and several drivers) tend to prefer the more clean version,
>>
>> 	{ },
>>
>> or even
>>
>> 	{ },	/* terminate list */
> 
> Ah, yes.  I see that now in some of the other drivers.  Should I re-send
> this patch (and/or the other PCI patches)?

Can't hurt...  but I cannot speak for other maintainers.

	Jeff



