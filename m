Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYDUUmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYDUUmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYDUUmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:42:24 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:33800 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYDUUmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:42:23 -0400
Message-ID: <2615.198.182.194.170.1208810542.squirrel@clueserver.org>
In-Reply-To: <86802c440804211232q39b35837ob50674718c617348@mail.gmail.com>
References: <48738.12.172.32.236.1208805186.squirrel@clueserver.org>
    <86802c440804211232q39b35837ob50674718c617348@mail.gmail.com>
Date: Mon, 21 Apr 2008 13:42:22 -0700 (PDT)
Subject: Re: Aperture memory hole on x86_64
From: "Alan" <alan@clueserver.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Alan" <alan@clueserver.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Apr 21, 2008 at 12:13 PM, Alan <alan@clueserver.org> wrote:
>> Something I noticed on my new AMD64 laptop with 4 gigs of RAM and a
>> 256meg
>>  video card.
>>
>>  I am running 2.6.25 from Fedora 9 beta.
>>
>>  When i boot, I get the following messages:
>>
>>  Checking aperture...
>>  Node 0: aperture @ 9816000000 size 32 MB
>>  Aperture beyond 4GB. Ignoring.
>>  No AGP bridge found
>>  Your BIOS doesn't leave a aperture memory hole
>>  Please enable the IOMMU option in the bios setup
>>  Mapping aperture over 65536 KB of RAM @ c000000
>>
>>  Is this a bug or is the x86_64 supposed to map the video aperture into
>>  something that is 32bit addressable?
>>
>>  Also, there is no video settings at all on this particular laptop in
>> bios.
>>   (It is an HP dv6700 with almost everything maxed out.)
>>
>>  Just curious if this is correct behavior or not. (Since I am using the
>>  xorg nv driver, it may not make any difference.)
>
> you have 4G ram installed, and hw mem hole is enabled, so you memory
> top is above 4g.
> and kernel need to use gart for iommu.
>
> and you bios didn't setup your gart because you didn't have agp..
>
> please check if you BIOS have setup for gart, and you can set size to
> 64M, and then you could get 64M ram back.

There is no memory or video related setting options in the bios at all. 
It is about as barebones as you can get.

If you want, I can send the output of dmesg or other diagnostics for this
machine.
