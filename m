Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZAXXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZAXXvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 18:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZAXXvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 18:51:08 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:50906 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZAXXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 18:51:07 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 18:51:06 EST
MIME-Version: 1.0
In-Reply-To: <20090124185612.5afddbb0@mjolnir.drzeus.cx>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	 <20090112160519.3ba21848@mjolnir.drzeus.cx>
	 <20090115150003.GB6896@shadowen.org>
	 <20090124185612.5afddbb0@mjolnir.drzeus.cx>
Date: Sun, 25 Jan 2009 00:45:46 +0100
Message-ID: <ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 18:56, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Thu, 15 Jan 2009 15:00:03 +0000
> Andy Whitcroft <apw@canonical.com> wrote:
>
>>
>> Would it make more sense to simply use mmc: with no data as the MODALIAS
>> tag here.  And make mmc-block have mmc:* as an alias.  That way the
>> actual (useless) numeric data is not exposed but we still will load the
>> mmc-block module for everything exactly as we do with the udev rule.
>> This should still make things work from a distro point of view and not
>> expose anything which might then get relied on.  If we do it so extra
>> data can still be added later we won't prevent sane data being exposed
>> should we ever have any.
>>
>> If you are happier with that I can re-spin the patches that way?
>>
>
> Well, as long as we're on the track of temporary hack, we might as well
> just export "mmc_block" as the modalias. Or would there be any
> side-effects to that?

The common format is to prefix with "<subsystem>:". Something like
"mmc:block" sounds fine to me.

Thanks,
Kay
