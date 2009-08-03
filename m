Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZHCOum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZHCOum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbZHCOum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:50:42 -0400
Received: from rtr.ca ([76.10.145.34]:40055 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbZHCOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:50:41 -0400
Message-ID: <4A76F941.5060006@rtr.ca>
Date: Mon, 03 Aug 2009 10:50:41 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ext4 ioctl(FIEMAP) bug? observed in 2.6.29.4 (32-bit x86)
References: <4A76069C.1010801@rtr.ca> <20090803074554.GA21042@skywalker>
In-Reply-To: <20090803074554.GA21042@skywalker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aneesh Kumar K.V wrote:
> On Sun, Aug 02, 2009 at 05:35:24PM -0400, Mark Lord wrote:
..
>> 2.6.29.4:
>> The output below shows the sequence of FIEMAP calls
>> on the single massive file.  Notice that the first call
>> returned the "LAST" flag set, despite there being many
>> many more extents after that bunch.
>>
> 
> Can you try with
> 
> commit c9877b205f6ce7943bb95281342f4001cc1c00ec
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Fri May 1 23:32:06 2009 -0400
> 
>     ext4: fix for fiemap last-block test
..

Ahh.. good to see it already upstream, thanks.

I cannot easily reproduce the bug, so no re-test here.
And my app (hdparm) simply now ignores the LAST flag as a workaround.

Thanks
