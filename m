Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZCDJ0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZCDJ0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZCDJ0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:26:25 -0500
Received: from relay.atmel.no ([80.232.32.139]:54892 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484AbZCDJ0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:26:24 -0500
Message-ID: <49AE492F.6020006@atmel.com>
Date: Wed, 04 Mar 2009 10:26:07 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 0/5] WM97xx updates
References: <20090303182402.GA29542@rakim.wolfsonmicro.main> <20090304091538.GD7394@dtor-d630.eng.vmware.com>
In-Reply-To: <20090304091538.GD7394@dtor-d630.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tue, Mar 03, 2009 at 06:24:03PM +0000, Mark Brown wrote:
>> This patch series updates the review feedback from the first round and
>> rolls in the additional patches from Mike Rapoport.  I've not addressed
>> any of the comments for the at32 driver since I have no ability to test
>> any changes to that driver but repost it for completeness.
>>
> 
> I applied first 4 patches to 'next' and will wait for Hans-Christian
> comments on the at32 driver.
> 

The only thing catched by review was a leaking irq line, do you plan to 
fixup that Mark?

I also think the header file could go into the source code, to make it 
one file less.

Also, please note that I've gotten a new email address. The old one is 
quite annoying since it sends email back about my new address...

I'll not be able to test the driver immediately, my hardware is out at 
customers and the eight new prototypes needs some resoldering before I 
can work with them. Nothing has changed in hardware though, so it should 
fly out of the box.

-- 
Best regards,
Hans-Christian Egtvedt
