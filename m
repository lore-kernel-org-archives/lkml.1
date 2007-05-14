Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXENSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXENSZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXENSZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:25:42 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:18465 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXENSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:25:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Py6LvFG8H1uIigty5UTxdJyh6ZU7YnMv11rObY6l/bwfFjSoehPwUcpF7noqj8O4K6TU136ZAKA8zeRXdU9iBK9C9boIAK38OK0q0iN1PahZgK1kBBjmVPJdrpKANpzVP7dfMTnx53pvXLHOVuSlrgsEm4g5hIArfY0rI4Pv5VA=
Message-ID: <5486cca80705141125p534d8f26j4c096510534272f4@mail.gmail.com>
Date: Mon, 14 May 2007 20:25:40 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Linux 2.6.22-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070514200819.12fdb184@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	 <5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	 <20070514081022.7fcee97f@hyperion.delvare>
	 <5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	 <20070514141437.631fcfd1@hyperion.delvare>
	 <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
	 <20070514172138.1c870793@hyperion.delvare>
	 <5486cca80705140904p307138bdx511bf2f186a07221@mail.gmail.com>
	 <20070514200819.12fdb184@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

2007/5/14, Jean Delvare <khali@linux-fr.org>:
[cut]
> > I've not found an obvious way to set it in sensors.conf. Could you
> > point me to some doumentation, thanks.
>
> sensors.conf supposedly _is_ the the documentation ;)
>
> Search for the following line in /etc/sensors.conf:
>
> chip "via686a-*"
>
> After this line, add:
>
> set fan1_div 4
> set fan2_div 4
>
> Save, quit, run "sensors -s" (as root), that should do it.

Thanks for the explanation (it's not too evident form sensors.conf ;)).

> > Is this new version required only for the via686 chip or should be a
> > general advise for Debian Etch users to upgrade to lm-sensors >=
> > 2.10.3 for kernels >= 2.6.22?
>
> The problem affects almost all hardware monitoring chips, so this is a
> general advice. I've added a note about it on the lm-sensors website.
>
> Alternatively though, you could have recompiled your kernel with
> CONFIG_SYSFS_DEPRECATED=y, then lm_sensors 2.10.1 would have worked
> fine again. Sorry for not mentioning this before, this might have been
> easier than upgrading lm_sensors.

No problem. I took no more than 5 min to do the backport instead of
~25 min of a full kernel built ;-). BTW it's always good to know the
various solutions.

Thanks,

    ~  Antonio
