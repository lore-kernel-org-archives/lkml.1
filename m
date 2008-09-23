Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYIWW5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYIWW5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIWW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:57:32 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:31383 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751313AbYIWW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:57:31 -0400
Date: Wed, 24 Sep 2008 02:57:30 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dbrownell@users.sourceforge.net,
       greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, leoli@freescale.com, timur@freescale.com
Subject: Re: [PATCH 3/3] USB: driver for Freescale QUICC Engine USB Host
	Controller
Message-ID: <20080923225730.GB13617@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru> <20080918151746.GC31187@oksana.dev.rtsoft.ru> <20080919162324.e354ed2f.akpm@linux-foundation.org> <20080923183129.GA19024@oksana.dev.rtsoft.ru> <48D96052.6090005@ru.mvista.com> <48D9612D.7060601@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <48D9612D.7060601@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 01:35:41AM +0400, Sergei Shtylyov wrote:
[...]
>>>>> This controller does not integrate the root hub, so this driver also
>>>>> fakes one-port hub. External hub is required to support more than
>>>>> one device.
>>>>>
>>>>> ...
>>>>>
>>>>>       
>>>> Please, no.
>>>>     
>>>
>>> What exactly 'no'? ;-)
>>>   
>>
>>   No one-port hubs I guess -- they are pointless. Though e.g. MUSB  
>> driver creates one -- I guess to impersonate a transaction translating  
>> high-speed hub...
>>
>
>   ... then the root hub emulation is completely pointless.

It isn't. We always should emulate the root hub. The root hub
is part and parcel of any USB Host. Even the one-port one.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
