Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYDPShy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYDPShy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYDPShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:37:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35661 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYDPShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:37:43 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5275"; a="2304857"
Message-ID: <48064775.7000902@qualcomm.com>
Date: Wed, 16 Apr 2008 11:37:41 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vitaliy Ivanov <vitalivanov@gmail.com>, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb: remove macro code obfuscation
References: <20080416104257.GA1621@elf.ucw.cz>	<35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com> <20080416112909.505fe619.akpm@linux-foundation.org>
In-Reply-To: <20080416112909.505fe619.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Apr 2008 13:51:37 +0300
> "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:
> 
>> On Wed, Apr 16, 2008 at 1:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>  with macros. Fix that.
>>>
>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>>
>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>  with macros. Fix that.
>>>
>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>
>> Got it from the first time;)
>>
>> Do you think that now code looks better? As for me it's not...
>>
> 
> Yes, I expect that the original code was easier to work with and it is not
> obfuscated I don't think.  Sometimes these things take a few minutes for
> new readers to become comfortable with but are good for people who work on
> the code regularly.
> 
> Although it's a mystery why __pending_tx() and friends
> 
> a) have leading underscores and
At the time I wrote it, it made sense (to me :)) but it's been such a long 
time ago I would not remember. Probably to show that this is something 
internal and needs to be used with caution.

> 
> b) are implemented in cpp, when C is available.
> 
I'm not sure what you mean ? #define vs inline I suppose ?

Max
