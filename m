Return-Path: <linux-kernel-owner+w=401wt.eu-S1761978AbYBSWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbYBSWJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYBSWJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:09:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58400 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBSWJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jLdGnDeuRMHXtClNu9awwmxjlNg5Js+AeJphdybIjaTzGjgNvx0i9lE73qKdUH9uCW0XUXNILXWeDZI31pGn1FeZ7JDbKbwJwzPteeTHtyOUjXzexIIO+gNmdc/6SbfmzM7a89FaSBKRWTKtAd9to1Sjb+MT6cetJkq3nBwXPrA=
Message-ID: <47BB537F.7030801@gmail.com>
Date: Wed, 20 Feb 2008 01:09:03 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] Enable the timerfd_*() o32 system calls
References: <1203368557-32356-1-git-send-email-dmitri.vorobiev@gmail.com> <20080219141940.GA14991@linux-mips.org>
In-Reply-To: <20080219141940.GA14991@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle пишет:
> On Tue, Feb 19, 2008 at 12:02:37AM +0300, Dmitri Vorobiev wrote:
> 
>> This patch enables the system calls timerfd_create(), timerfd_settime()
>> and timerfd_gettime() for MIPS architecture.
>>
>> Please see the following Bugzilla entry for more details:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=10038
>>
>> This was tested using a Malta 4Kc board in both little-endian and
>> big-endian modes. The unit test program is available from the URL
>> above.
>>
>> Note that only the "o32"-style system calls have been added. This is
>> due to the fact that I have no suitable equipment to test the other
>> flavors of MIPS ABI.
> 
> Thanks.  I added the missing bits for the others ABIs and applied the
> combined patch.

Thank you, Ralf!

Dmitri

> 
>   Ralf
> 

