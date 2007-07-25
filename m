Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXGYRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXGYRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXGYRwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:52:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:25518 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752597AbXGYRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:52:06 -0400
Message-ID: <46A78E3F.1030904@ru.mvista.com>
Date: Wed, 25 Jul 2007 21:54:07 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain>	<20070725165326.5331.19920.stgit@localhost.localdomain> <46A78322.3080607@ru.mvista.com>
In-Reply-To: <46A78322.3080607@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>diff --git a/arch/powerpc/boot/dts/mpc8349emitx.dts b/arch/powerpc/boot/dts/mpc8349emitx.dts
>>index db0d003..f8f0e8a 100644
>>--- a/arch/powerpc/boot/dts/mpc8349emitx.dts
>>+++ b/arch/powerpc/boot/dts/mpc8349emitx.dts
>>@@ -37,6 +37,15 @@
>> 		reg = <00000000 10000000>;
>> 	};
>> 
>>+	ide@f0000000 {
>>+		compatible = "mmio-ide";
>>+		device_type = "ide";

>     Why not "ata"?

    Also, what mmio-ide in the compat properly means in the context of 
ide_platform which is able to handle both port and memory mapped IDE. I think 
we must get rid with this crap, and since this IDE register mapping is pretty 
much board specific, call it something like "mpc8349emitx-ide" instead.

MBR, Sergei
