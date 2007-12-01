Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXLAMR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXLAMR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXLAMRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:17:42 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39925 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbXLAMRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:17:41 -0500
Date: Sat, 1 Dec 2007 13:17:40 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
In-Reply-To: <Pine.LNX.4.64.0712010711380.25643@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0712011313490.30316@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712010711380.25643@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 1 2007 07:12, Justin Piszcz wrote:
> On Sat, 1 Dec 2007, Jan Engelhardt wrote:
>> On Dec 1 2007 06:19, Justin Piszcz wrote:
>>
>> > RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>> > you use 1.x superblocks with LILO you can't boot)
>>
>> Says who? (Don't use LILO ;-)
>
> I like LILO :)

LILO cares much less about disk layout / filesystems than GRUB does,
so I would have expected LILO to cope with all sorts of superblocks.
OTOH I would suspect GRUB to only handle 0.90 and 1.0, where the MDSB
is at the end of the disk <=> the filesystem SB is at the very beginning.

>> > So two questions:
>> >
>> > 1) If it rebuilt by itself, how come it only rebuilt /dev/md0?
>>
>> So md1/md2 was NOT rebuilt?
>
> Correct.

Well it should, after they are readded using -a.
If they still don't, then perhaps another resync is in progress.
