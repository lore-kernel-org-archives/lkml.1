Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbZGFIM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbZGFIM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZGFIMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:12:52 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45249 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZGFIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:12:51 -0400
Message-ID: <4A51B204.4090501@petalogix.com>
Date: Mon, 06 Jul 2009 10:12:52 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add checksum selftest
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> <200906241724.30947.arnd@arndb.de> <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com> <200906251255.06984.arnd@arndb.de>
In-Reply-To: <200906251255.06984.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 24 June 2009, Mike Frysinger wrote:
>   
>> ok, i can see that for the result, but how do i handle the functions
>> that also take a __wsum ?  do i just always pass them 0 to avoid
>> implementation issues ?
>>     
>
> No, any __wsum you pass in there should be fine, because that one
> gets folded in in the end.
>   
Mike do you have any updated patch? I would like to check it on
Microblaze too.

Thanks,
Michal

> 	Arnd <><
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

