Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYJVNgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYJVNgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYJVNgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:36:12 -0400
Received: from poesci.dolphinics.no ([81.175.23.36]:44009 "EHLO
	poesci.dolphinics.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYJVNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:36:12 -0400
Message-ID: <48FF2C43.6010702@dolphinics.no>
Date: Wed, 22 Oct 2008 15:36:03 +0200
From: Simen Thoresen <simentt@dolphinics.no>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: File as generic block-device?
References: <48FF2304.8070301@dolphinics.no> <Pine.LNX.4.64.0810221529200.29342@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0810221529200.29342@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 22 Oct 2008, Simen Thoresen wrote:
>> I have a project where I require to treat a file as a block-device
>> (specifically, I want a file on an ext3 fs to act as one of the raid-members
>> in a md-based stripe-set. I know that I can make a /filesystem/ on a file
>> because both mkfs and mount (with -o loop) will accept a file as a
>> block-device, but I have found no such function for mdadm, and am thus asking
>> for a kernel-internal way to re-plug a file into the block-device layer.
>>
>> Is this possible?
> 
> Sure! You just have to create the loop device (/dev/loop*) yourself using
> losetup(8). `mount -o loop' does it itself behind your back.

Ah! Perfect, thank you.

-S

> With kind regards,
> 
> Geert Uytterhoeven
> Software Architect
> 
> Sony Techsoft Centre Europe
> The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
> 
> Phone:    +32 (0)2 700 8453
> Fax:      +32 (0)2 700 8622
> E-mail:   Geert.Uytterhoeven@sonycom.com
> Internet: http://www.sony-europe.com/
> 
> A division of Sony Europe (Belgium) N.V.
> VAT BE 0413.825.160 · RPR Brussels
> Fortis · BIC GEBABEBB · IBAN BE41293037680010


-- 
Simen Thoresen - Dolphin ICS Systems Administrator
