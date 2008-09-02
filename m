Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYIBFNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYIBFNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYIBFNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:13:39 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:53846 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbYIBFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:13:38 -0400
Date: Tue, 02 Sep 2008 01:13:23 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
In-reply-to: <3f9a31f40809010951p15ed7359w48d2b18adf0ca20f@mail.gmail.com>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Message-id: <200809020113.24058.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <898503EB1E15BA4F944D1BE69D55AAC8AB540A@storexmb1.amd.com>
 <200808310655.45464.gene.heskett@gmail.com>
 <3f9a31f40809010951p15ed7359w48d2b18adf0ca20f@mail.gmail.com>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008, Jaswinder Singh wrote:
>Hello Gene,
>
>On Sun, Aug 31, 2008 at 6:55 AM, Gene Heskett <gene.heskett@gmail.com> wrote:
>> Yes I can, but how do I get that specific patch?  Or is that the git # for
>> the patch I first applied to -rc2, which added the firmware/radeon stuff? 
>> I'm familiar with patch, but not on a first name basis with git, sorry.
>>
>> So I'm going to do a bisect, my style.  I will rebuild, starting with
>> -rc3, using only the -rcX patch and the firmware addition patch, which
>> applied to -rc3 as follows:
>> now applying [PATCH]radeon_cp-use-request_firmware
>
>This patch is not included in 2.6.27-rc5. Please do not mix this patch
>now, first resolve your problem and if you want then you can add this
>patch above of it.
>
I see.  However, since the stuff in /lib/firmware is already there from 
previous builds that did include this patch, and I didn't delete it, I noted 
that the 2.6.27-rc5 I built last night, without that patch, still loaded the 
r200 microcode according to the messages log, and dmesg.  From dmesg:

[root@coyote /]# dmesg|grep drm
[    1.389274] [drm] Initialized drm 1.1.0 20060810
[    1.389707] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   85.920881] [drm] Setting GART location based on new memory map
[   85.920894] [drm] Loading R200 Microcode
[   85.920944] [drm] writeback test succeeded in 1 usecs

>Thank you,
>
>Jaswinder Singh.

Thank you!

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Good leaders being scarce, following yourself is allowed.
