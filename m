Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0CCPRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:17:10 -0500
Received: from mail-pz0-f185.google.com ([209.85.222.185]:58857 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0CCPRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:17:06 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 10:17:06 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LVk2t94O3K8iFts0cVtRloyCfbyNhd6zs2prn4DLKSUti8Dzh7Uxn3McS9NqHleuYu
         JUuQoijcTqTLwEWPMma+dz3zkhb6amNJGbPKNqPt/3D/dTjMEjuzO9bxOb0W6FHJ2hIv
         1AJCJkPeNUALsbi9+Qn1b/Ui9LMjtfEn5+228=
MIME-Version: 1.0
In-Reply-To: <201003021451.59773.arnd@arndb.de>
References: <1267506354.1618.4.camel@virtubuntu>
	 <201003021451.59773.arnd@arndb.de>
Date: Wed, 3 Mar 2010 20:39:06 +0530
Message-ID: <9debc4411003030709r597d4f6dmeacadce5c3cf2ed7@mail.gmail.com>
Subject: Re: yaffs2 NAND fs
From: Maxin John <maxin.john@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Paul <abnominales@web.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 2, 2010 at 7:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 02 March 2010, Peter Paul wrote:
>> I was wondering why the yaffs2 file system has not gone for mainline
>> yet. It's rather popular flash file system in the embedded world, while
>> it is rather easy to patch a kernel to have yaffs2 support [1] it would
>> be even nicer if it was just in mainline.
>> The source of the GPLv2 file system can be found at [2]
>>
>> [1] http://www.yaffs.net/howto-incorporate-yaffs
>> [2] http://www.aleph1.co.uk/cgi-bin/viewcvs.cgi/yaffs2/
>
> I would guess it's a combination of multiple reasons:
>
> 1. It has not been submitted for upstream inclusion, at least not
>   during the last few years.
> 2. We don't have a staging area like drivers/staging for file systems
>   in the way that we have for drivers
> 3. There is now ubifs and (soon) logfs upstream, both of which appear
>   to be superior to yaffs in many ways.

This means there should be no reference to YAFFS2 in the upstream
kernel? Because, I have located some defconfigs in upstream kernel
where YAFFS2 support is enabled by default.
ie:
CONFIG_YAFFS_YAFFS2=y
CONFIG_YAFFS_AUTO_YAFFS2=y
in below listed files:

1. arch/arm/configs/msm_defconfig
2. arch/blackfin/configs/IP0X_defconfig
3. arch/blackfin/configs/SRV1_defconfig
4. arch/blackfin/configs/BlackStamp_defconfig
5. arch/blackfin/configs/BF533-EZKIT_defconfig
6. arch/arm/configs/cam60_defconfig
7. arch/blackfin/configs/BF538-EZKIT_defconfig
8. arch/blackfin/configs/BF533-STAMP_defconfig
9. arch/blackfin/configs/PNAV-10_defconfig
10. arch/blackfin/configs/BF537-STAMP_defconfig
11. arch/blackfin/configs/BF526-EZBRD_defconfig
12. arch/blackfin/configs/BF527-EZKIT_defconfig,

Please let me know your opinion on this.

Best Regards,
Maxin B. John
