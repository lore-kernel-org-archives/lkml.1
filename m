Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXJWUkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXJWUkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXJWUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:40:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55375 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXJWUkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:40:05 -0400
Message-ID: <471E5C21.8030908@garzik.org>
Date: Tue, 23 Oct 2007 16:40:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Add eeprom_bad_csum_allow module option to e1000.
References: <11931515302013-git-send-email-ajax@redhat.com>	 <471E1ECD.80002@intel.com> <1193156487.26974.39.camel@localhost.localdomain> <471E2AD0.1000500@intel.com>
In-Reply-To: <471E2AD0.1000500@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Adam Jackson wrote:
>> On Tue, 2007-10-23 at 09:18 -0700, Kok, Auke wrote:
>>> Adam Jackson wrote:
>>>> When the EEPROM gets corrupted, you can fix it with ethtool, but only if
>>>> the module loads and creates a network device.  But, without this option,
>>>> if the EEPROM is corrupted, the driver will not create a network device.
>>>>
>>>> Signed-off-by: Adam Jackson <ajax@redhat.com>
>>> NAK
>>>
>>> wrong list, not sent to me, and while for e100 I was OK with this patch, for e1000
>>> it really does not make sense to 'just allow' a bad checksum - if your eeprom is
>>> randomly messed up then you cannot just fix it like this anyway.
>> That's strange, I managed to recover an otherwise horked e1000 with it.
>> What should I have done instead?
> 
> 
> Dump the eeprom and send us a copy, plus any and all information to the card,
> system etc.. I realize that you need the patch to actually create it but the
> danger is that people will start using it *without* troubleshooting the real
> issue. In various systems the eeprom checksum failure is actually due to a
> misconfigured powersavings feature and the checksum is really not bad at all, but
> the card just reports random values.
> 
> In any case, this patch should not be merged. We often send it around to users to
> debug their issue in case it involves eeproms, but merging it will just conceal
> the real issue and all of a sudden a flood of people stop reporting *real* issues
> to us.


Sorry, I disagree.  Just as with e100, if there is a clear way the user 
can recover their setup -- and Adam says his was effective -- I don't 
see why we should be denying users the ability to use their own hardware.

	Jeff


