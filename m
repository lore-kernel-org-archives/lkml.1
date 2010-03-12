Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0CLJdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 04:33:55 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38032 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0CLJds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 04:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=F4i6cEI8ARUKl6YXB2oesiJPYS/zkHLbvpZvpMCya3rS+Az/B0JmLYLSD0n5gGMsWK
         uYb2zxd+Xyo5xP81XNg4QtouTVs+M1Av6kpBXZQY7+kUo8KSir0GYSx4x+4/b8/ddcO2
         xXKvtiL026LtjidzjxC5lA8O0OJILsYIdrqps=
Message-ID: <4B9A0A71.7010206@warmcat.com>
Date: Fri, 12 Mar 2010 09:33:37 +0000
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stanislav Brabec <utx@penguin.cz>
CC: Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
Subject: Re: bit errors on spitz
References: <20100305212708.GC21773@elf.ucw.cz>	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>	 <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz>
In-Reply-To: <1268384824.4963.35.camel@utx.utx.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/10 09:07, Somebody in the thread at some point said:

>> Unless there's more to it in the way the zaurus using it that regulator
>> isn't programmable digitally.
>
> OOPS, I made a mistake and linked ISL6721 instead of ISL6271 there.
> Now it is fixed:
> http://www.penguin.cz/~utx/zaurus/datasheets/power/XScale/ISL6271A.pdf
>
> This one has I2C. It is connected to GPIO 3 (PWR_SCL) and GPIO 4
> (PWR_SDA).

Thanks... that defaults to 1.3V on Vcore if you don't touch it.  I guess 
confirm on the CPU datasheet that it's OK for your selected CPU clock speed.

> I guess that Zaurus has a good power design and that voltage should be
> constant enough. CF has a dedicated step down (plus 2.8V power detector

In that case is the PXA CF driver PIO?  Then it can be the same load on 
Vcore issue in disguise.

-Andy
