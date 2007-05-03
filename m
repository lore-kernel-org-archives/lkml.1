Return-Path: <linux-kernel-owner+w=401wt.eu-S1031222AbXECMkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031222AbXECMkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031297AbXECMkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:40:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59456 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031286AbXECMkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:40:46 -0400
Date: Thu, 3 May 2007 14:40:30 +0200 (CEST)
From: Jan Kratochvil <honza@jikos.cz>
To: Dmitry Torokhov <dtor@insightbb.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/3] xpad.c: Added flags into xpad_device structure and
 removed dpad_mapping.
In-Reply-To: <200705022238.36454.dtor@insightbb.com>
Message-ID: <alpine.LRH.0.98.0705031438220.22353@twin.jikos.cz>
References: <Pine.LNX.4.64.0705021644580.13550@twin.jikos.cz>
 <200705022238.36454.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 2 May 2007, Dmitry Torokhov wrote:

> Hi Jan,
>
> On Wednesday 02 May 2007 11:01, Jan Kratochvil wrote:
>> This changes are expected to simplify further improves of this driver,
>> We will need to add information if the driver is xbox360 device or not.
>>
>> Second option was to simply add u8 is_360, but what if we'll need to know
>> if device is a wheel? Or if the device can have keyboard (or headset) attached.
>>
>
> ...
>
>> -#define MAP_DPAD_TO_BUTTONS    0
>> -#define MAP_DPAD_TO_AXES       1
>> -#define MAP_DPAD_UNKNOWN       -1
>> +#define XPAD_FLAGS_DPAD_TO_BUTTONS    (1 << 0)
>> +#define XPAD_FLAGS_DPAD_TO_AXES       (1 << 1)
>> +#define XPAD_FLAGS_DPAD_UNKNOWN       (1 << 2)
>>
>
> Turning this into bitmaps suggests that all of these could be set which is
> not the case. Since there are 3 spare bytes in xpad_device structure to
> use for additional flags/bitmaps I'd leave dpad_mapping alone.

Ok. Lets ignore this patch.

>
> --
> Dmitry
>

Jan Kratochvil
