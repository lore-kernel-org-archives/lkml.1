Return-Path: <linux-kernel-owner+w=401wt.eu-S1764086AbXK3TJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764086AbXK3TJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXK3TJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:09:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXK3TJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:09:15 -0500
Message-ID: <47505FC6.9030208@zytor.com>
Date: Fri, 30 Nov 2007 11:08:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: 2.6.23: does it supposed to work on an i486?
References: <47504923.9030309@msgid.tls.msk.ru> <4750519C.2000907@zytor.com> <475059D6.2080900@msgid.tls.msk.ru>
In-Reply-To: <475059D6.2080900@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
>> It looks like 2.6.23.9 is missing checkin
>> 7ed192906a2144ebc8ca2925a85d27b9c5355668 from Linus' tree (attached),
>> which is necessary to work on 386 and 486.
> 
> Well, I applied the patch (in 2.6.23 it's
>  arch/i386/boot/pmjump.S,
> not
>  arch/x86/boot/pmjump.S,
> but that's minor) - still the same behavior, it still reboots
> instantly right when bootloader gave control to the kernel.
> So it must be something else.. ;)

Well, it's a good bet it's croaking somewhere in the setup code 
(arch/{i386,x86}/boot).  Putting debugging statements there might help.

	-hpa
