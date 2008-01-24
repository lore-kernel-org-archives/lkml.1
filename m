Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYAXXiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYAXXiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYAXXio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:38:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:29350 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYAXXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:38:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xLFvWO6RpTCS4n2us6nyrqIyXaRDbOaOm2KpwcwVrrlsZFXfk2uVhfNkEA8rf40RgMptR7MFYxH+V1Zlgv1NsQyRTp5r916FEWCAlt9tlURDCzOQgj2gD/KxYMRTaUjKJGNgV6ncnjbh8NwRvElY9vXtV3Z73OpbDhm7XPNW5R8=
Message-ID: <4799217F.4020805@gmail.com>
Date: Fri, 25 Jan 2008 00:38:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
References: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk> <479521F7.9050701@gmail.com> <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk> <47975F33.6040206@gmail.com> <Pine.LNX.4.64.0801250013410.3424@dbs1.uni-c.dtu.dk>
In-Reply-To: <Pine.LNX.4.64.0801250013410.3424@dbs1.uni-c.dtu.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2008 12:34 AM, Oyvind Aabling wrote:
> Ah, I see, you want to get rid of moxaload altogether ...

Yes, I don't like such a loaders :).

> I'll test your patch series as soon as I get a chance - need to put a
> MOXA card into a non-production machine first, so it'll be a few days.

Ok, thanks, no problem.

> We have a few MOXA Intellio C320 Turbo PCI
> cards, here's lspci -vvxxx for one of them:
> 
> 02:02.0 Serial controller: Moxa Technologies Co Ltd Intellio C320 Turbo 
> PCI (rev 02) (prog-if 80)
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 16
>         Region 1: I/O ports at 9400 [size=128]
>         Region 2: Memory at fb200000 (32-bit, non-prefetchable) [size=16K]
[...]
> The other cards looks identical, except for unimportant differences
> in region mapping and IRQ allocation due to system differences.

OK, doesn't matter, I was just curious if region 2 is really mem space.

thanks,
--js
