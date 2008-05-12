Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYELNwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYELNwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYELNwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:52:20 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:38188 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYELNwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:52:19 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2008 09:52:19 EDT
Date: Mon, 12 May 2008 15:22:17 +0200
From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: cross-compiling on OS X, make menuconfig fails
In-reply-to: <ed10ee420805030234o39141933v8c26d7895ed3f9a@mail.gmail.com>
To: SL Baur <steve@xemacs.org>
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>,
       Sam Ravnborg <sam@ravnborg.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Timur Tabi <timur@freescale.com>, Tony Breeds <tony@bakeyournoodle.com>,
       linux-kernel@vger.kernel.org
Message-id: <48284489.4040609@arndnet.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.27,473,1204498800";   d="scan'208";a="42528882"
References: <481529B6.6030802@freescale.com>
 <20080428015151.GW20457@bakeyournoodle.com> <481739BF.8010305@freescale.com>
 <20080429164535.GB18018@uranus.ravnborg.org>
 <20080429172057.GN5882@ZenIV.linux.org.uk>
 <20080429180601.GA19652@uranus.ravnborg.org>
 <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
 <5460B94D-5B3B-4174-9432-C45521A9C247@e18.physik.tu-muenchen.de>
 <ed10ee420805030234o39141933v8c26d7895ed3f9a@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SL Baur wrote:
> On 5/3/08, Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> wrote:
>   
>> Hi Steve!
>>
>>
>>  On 3 May 2008, at 08:55, SL Baur wrote:
>>     
>
>   
>>> $ uname -v
>>> Darwin Kernel Version 8.11.1: Wed Oct 10 18:23:28 PDT 2007;
>>> root:xnu792.25.20~1/RELEASE_I386
>>>
>>>
>>>       
>>  Yes, they changed that between Tiger and Leopard, where I have
>>
>>  ---
>>  $ uname -v
>>  Darwin Kernel Version 9.2.2: Tue Mar  4 21:17:34 PST 2008;
>> root:xnu-1228.4.31~1/RELEASE_I386
>>  $ /bin/bash -c 'echo -e "buh\n"'
>>  buh
>>
>>  $ /bin/sh -c 'echo -e "buh\n"'
>>  -e buh
>>
>>  $ /bin/echo -e "buh\n"
>>  -e buh\n
>>  ---
>>
>>  The second one is POSIX+XSI, the third one plain POSIX. The first one is
>> what people are used to ;-)
>>     
>
> Check.
>
> $ /bin/bash -c 'echo -e "buh\n"'
> buh
>
> $ /bin/sh -c 'echo -e "buh\n"'
> buh
>
> $ /bin/echo -e "buh\n"
> -e buh\n
>
> Of all the things to "standardize" on, why something like bash
> which has no standards?  pdksh, ash, dash or POSIX mode zsh,
> would have been better...
>
>   
It also depends on the shell option xpg_echo IIRC.
If xpg_echo is off echo -e should work in /bin/sh, too.

Regards,
Arnd



