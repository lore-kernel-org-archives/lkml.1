Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIXTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIXTRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYIXTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:16:59 -0400
Received: from h155.mvista.com ([63.81.120.155]:4899 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752095AbYIXTQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:16:58 -0400
Message-ID: <48DA9263.5060103@ru.mvista.com>
Date: Wed, 24 Sep 2008 23:17:55 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
Cc: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leoli@freescale.com, timur@freescale.com
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB Host Controller
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru> <20080923225730.GB13617@oksana.dev.rtsoft.ru> <48DA1544.5010307@ru.mvista.com> <200809241159.04427.david-b@pacbell.net>
In-Reply-To: <200809241159.04427.david-b@pacbell.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Brownell wrote:

>>>>  ... then the root hub emulation is completely pointless.

>>>It isn't. We always should emulate the root hub. The root hub
>>>is part and parcel of any USB Host. Even the one-port one.

>>   Hm, maybe that's what USB core thinks (because UHCI/OHCI/EHCI all 
>>have it) but e.g. MUSB doesn't have the root hub registers...

> Only the OHCI registers have bit positions matching what the USB
> spec says for hub status bits.

    Oh, didn't know that.

> Everything else, including musb_hdrc, has the relevant status encoded in other bits.

    Yes, but I thought that if there are no multiple ports, having the hub is 
just pointless.

>>I looked at the core and figured that USB core seems to use the root hub 
>>interface for port PM, etc. and expects it to bee present, so it seems 
>>unavoidable indeed... :-/

> Or more fundamentally:  for enumeration.  "Unavoidable" is correct.  ;)

    Not sure what you mean here but I guess having a root hub alows an uniform 
model of controlling the ports... anyway, USB specifies that it must be 
present in the host.

WBR, Sergei
