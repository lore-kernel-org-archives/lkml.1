Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXGLKPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXGLKPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXGLKPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:15:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:43010 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXGLKPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:15:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jgp+sh7Y0zy47n9YZ4hVFh8EpNuQNEf/6zrFjZEr2fKHEGE3kq2cwrK8SlgcYJCYCCpTLuxSralSfu9MS1L/a79RisBiQ5ImcuNyXHYiTJgHKTti5RD7Q7+ui3FwOA4I8ql1BZMZcpszvh98Y6Jb52qzBOZ9iNfcCuHh2Unf2xc=
Message-ID: <4695FF3E.60307@gmail.com>
Date: Thu, 12 Jul 2007 14:15:26 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Richard Hughes <hughsient@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Zhang Rui <rui.zhang@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the scheduled ACPI_PROCFS removal
References: <20070709145755.GD3492@stusta.de>	 <20070709174544.2a6b7067@the-village.bc.nu>	 <Pine.LNX.4.64.0707092044520.2887@fbirervta.pbzchgretzou.qr>	 <46951969.4030109@tmr.com>  <4695BCEA.4060108@gmail.com> <1184231897.2380.2.camel@work>
In-Reply-To: <1184231897.2380.2.camel@work>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hughes wrote:
> On Thu, 2007-07-12 at 09:32 +0400, Alexey Starikovskiy wrote:
>>>> [*] Does someone have an alternative for
>>>> /proc/acpi/battery/BAT1/{state,info}?
>> I'm working on it. Should have proto by the end of week.
> 
> If you are using the power_supply class (i hope you are ;-) then a HAL
> from freedesktop git should make userspace continue to just work. Please
> yell if you notice any differences.
Well, both SBS and CM batteries were able to set an alarm capacity. 
I did not found write capability to property in power_supply class yet.
So consider this a yelling :)

Thanks,
Alex.
