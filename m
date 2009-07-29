Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZG2MpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZG2MpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZG2MpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:45:15 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:37992 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbZG2MpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:45:15 -0400
Message-ID: <4A704451.1070004@mnementh.co.uk>
Date: Wed, 29 Jul 2009 13:45:05 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: Re: [PATCH 1/2] power_supply: get_by_name and set_charged	functionality
References: <20090723183451.GI13236@buzzloop.caiaq.de> <1248374154-15606-1-git-send-email-daniel@caiaq.de> <20090728220635.GH19257@buzzloop.caiaq.de> <4A70249C.6060705@f2s.com> <20090729103659.GI19257@buzzloop.caiaq.de>
In-Reply-To: <20090729103659.GI19257@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On Wed, Jul 29, 2009 at 11:29:48AM +0100, Ian molton wrote:
>> Looks ok. the only comment I have right now is that the comment doesnt  
>> quite match the patch - it suggests that the patch doesnt include the  
>> power_supply_set_battery_charged() function, when it does in fact.
> 
> The subject mentions it, and the body references it again. Hmm. Anyway.
> Want me to resend? Or could the commiter add another sentence to point
> that out? I think that would be Anton, as he agreed to pick all the
> other patches I recently sent in.

I'm not that fussed - you just seemed to want feedback, so I had a read ;-)

If you change it, I'd write something like:

This adds a function that indicates that a battery is fully charged. It 
also includes functions to get a power_supply device from the class of 
registered devices by name reference. These can be used to find a 
specific battery to call power_supply_set_battery_charged() on.

Some battery drivers might need this information to calibrate
themselves.

Or something.
