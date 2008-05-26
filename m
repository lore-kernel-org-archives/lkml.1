Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYEZMFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYEZMFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYEZMFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:05:23 -0400
Received: from terman.e-hosting.lu ([80.92.79.12]:36184 "EHLO
	terman.e-hosting.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYEZMFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:05:23 -0400
Authentication-Results: terman.e-hosting.lu; dkim=pass (1024-bit key) header.i=@trypill.org
Authentication-Results: terman.e-hosting.lu from=georges@trypill.org; domainkeys=pass (testing)
DomainKey-Signature: a=rsa-sha1; s=2008; d=trypill.org; c=nofws; q=dns;
	b=LexXnL+DK2wrwzE21hHNDmxQlhtvCsJ7/1jEDJoqMV5U/MkRVMIxBCw0QTuHLsSvG
	AgDZ3IE4hg/CnDBGEBJDY/aN+qJOMLuptwbNEFZx68zoG/wxkdMxP6Vpw58lpbRQ/DG
	YB1px6Q4X0EKXYuwVoLJNOSvaSDHomnPxhiBm+I=
Message-ID: <483AA746.3000501@trypill.org>
Date: Mon, 26 May 2008 14:04:22 +0200
From: Georges Toth <georges@trypill.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: BUG: unable to handle kernel paging request at ffff81013a612000
References: <483A8D59.2070302@trypill.org> <19f34abd0805260421o363f61c3r9682d3c6a38056f8@mail.gmail.com>
In-Reply-To: <19f34abd0805260421o363f61c3r9682d3c6a38056f8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Vegard Nossum wrote:
> It seems that you have three proprietary modules loaded: vmnet, vmmon,
> and nvidia (identified by the (P) suffix in module list above).
> Especially the vmnet and vmmon modules which have been loaded forcibly
> (the F suffix).
>
> This means that it will be very hard for the mainline developers to
> debug your problem. Most likely your report will be ignored.
>
> I suggest starting your system without loading these kernel modules in
> the first place. Note: It is important that the modules are not loaded
> in the first place. Simply unloading them won't work, as the damage
> may have been done already. If you can reproduce the problem when
> these modules have not been loaded, then I am sure it will be
> inspected properly.
>
> If you cannot reproduce the problem, however, I would try to narrow
> down the problem by loading only one or the other of the modules, then
> contact the vendor(s) of the offending modules.
>
> The easiest way to prevent a module from loading at boot is to remove
> the corresponding .ko file from /lib/modules/<kernel-version>/. (But
> keep the original file if you want to move it back later.)
>   
As suggested I've removed all proprietary modules and am using the nv 
xorg module for now.
Should that bug occur again, I'll let you know :-).

Thanks

-- 
regards,

Georges Toth

