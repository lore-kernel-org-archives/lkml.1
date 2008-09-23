Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYIWVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYIWVcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYIWVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:32:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:46596 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751535AbYIWVcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:32:12 -0400
Message-ID: <48D96052.6090005@ru.mvista.com>
Date: Wed, 24 Sep 2008 01:32:02 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leoli@freescale.com, timur@freescale.com
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB Host	Controller
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru>	<20080918151746.GC31187@oksana.dev.rtsoft.ru>	<20080919162324.e354ed2f.akpm@linux-foundation.org> <20080923183129.GA19024@oksana.dev.rtsoft.ru>
In-Reply-To: <20080923183129.GA19024@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

>>> This patch adds support for the FHCI USB controller, as found
>>> in the Freescale MPC836x and MPC832x processors. It can support
>>> Full or Low speed modes.
>>>
>>> Quite a lot the hardware is doing by itself (SOF generation, CRC
>>> generation and checking), though scheduling and retransmission is on
>>> software's shoulders.
>>>
>>> This controller does not integrate the root hub, so this driver also
>>> fakes one-port hub. External hub is required to support more than
>>> one device.
>>>
>>> ...
>>>
>>>       
>> Please, no.
>>     
>
> What exactly 'no'? ;-)
>   

   No one-port hubs I guess -- they are pointless. Though e.g. MUSB 
driver creates one -- I guess to impersonate a transaction translating 
high-speed hub...

WBR, Sergei


