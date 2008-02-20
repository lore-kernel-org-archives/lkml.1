Return-Path: <linux-kernel-owner+w=401wt.eu-S1764537AbYBTN42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764537AbYBTN42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbYBTN4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:56:19 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:48099
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbYBTN4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:56:18 -0500
Message-ID: <47BC3121.8070902@qumranet.com>
Date: Wed, 20 Feb 2008 15:54:41 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] build #365 issue for v2.6.25-rc2-342-g5d9c4a7 in
 ./arch/x86/kvm/kvm.ko
References: <200802201411.18026.toralf.foerster@gmx.de>
In-Reply-To: <200802201411.18026.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Hello,
>
> the build with the attached .config failed, make ends with:
> ...
>   HOSTCC  arch/x86/boot/tools/build
>   BUILD   arch/x86/boot/bzImage
> Root device is (3, 8)
> Setup is 12280 bytes (padded to 12288 bytes).
> System is 2192 kB
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 211 modules
> ERROR: "smp_ops" [arch/x86/kvm/kvm.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
>
> The build was made with :
> $> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make
>
> Here's the config:
>   

Looks like KVM conflicts with CONFIG_VOYAGER...

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

