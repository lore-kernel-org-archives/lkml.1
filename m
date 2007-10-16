Return-Path: <linux-kernel-owner+w=401wt.eu-S934645AbXJPQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934645AbXJPQBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934531AbXJPQAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:00:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934535AbXJPQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:00:52 -0400
Message-ID: <4714E02D.7040804@garzik.org>
Date: Tue, 16 Oct 2007 12:00:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chuck Ebbert <cebbert@redhat.com>,
       Konstantin Kalin <konstantin.kalin@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: NVIDIA Ethernet & invalid MAC
References: <4714C66D.4010607@gmail.com>	<20071016154313.53d19c43@the-village.bc.nu>	<4714D5B8.8020301@redhat.com> <20071016164354.6f4e530a@the-village.bc.nu>
In-Reply-To: <20071016164354.6f4e530a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> See the below for another report of this:
>>
>> http://marc.info/?t=119215716900001&r=1&w=2
>>
>> And apparently some motherboard vendors have their own allocations for ethernet
>> addresses?
> 
> We can teach it two ranges. I doubt anyone will be unlucky enough to have
> the one which could be either Nvidia or Gigabyte and have it matter.
> 
> The "go complain to the BIOS vendor" comment from Nvidia to me isn't an
> answer. Maybe Nvidia can complain to BIOS vendors but end user complaints
> of that form rarely have any effect.

That wasn't the point of the response at all.  The datum is that set of 
users where DEV_HAS_CORRECT_MACADDR is accurately set or clear is vast 
majority of cases.

For the rest, we'll want to look at adjusting DEV_HAS_CORRECT_MACADDR 
based on DMI strings or a hueristic like you suggested.

	Jeff


