Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0CKVVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:21:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38131 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0CKVVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:21:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SGk2lpXHA2ZbR6POh8vqEBwNO7xzyDbV7awKK21rrNIJNgaYS8rlBoaKAlCtlQHA5V
         5RIRR+l0ZNQW+Kvw6iMfOMNUFGbTrvsRzTjWvLt+AkqR5KZDsPDQEPLWHmWCXEsHem8d
         2yfMDIWFyR2D/4r1Q6A0tPHG9wl5gRsCd1kr4=
Message-ID: <4B995EE1.1050609@warmcat.com>
Date: Thu, 11 Mar 2010 21:21:37 +0000
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
References: <20100305212708.GC21773@elf.ucw.cz>	<f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>	<20100308072858.GA29939@atrey.karlin.mff.cuni.cz>	<20100308082530.GA1982@atrey.karlin.mff.cuni.cz>	<4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>
In-Reply-To: <1268322155.3990.114.camel@hammer.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/10 15:42, Somebody in the thread at some point said:
> Andy Green wrote:
>
>> I saw very similar failures for a long time on our iMX31 based device.
>> Eventually I found a Freescale errata where the RAM inside the USB2
>> macrocell started to make single bit errors below 1.38V Vcore; ours was
>> 1.4V at that time but dipped on CPU load.
>
> Good tip. It seems that nobody ported driver for the voltage control
> chip ISL6271 from 2.4 kernel, and bootloader probably does not set
> correct values.
>
> Datasheet:
> http://www.penguin.cz/~utx/zaurus/datasheets/power/Xscale/ISL6271.pdf

Unless there's more to it in the way the zaurus using it that regulator 
isn't programmable digitally.

Reading about your CF Card WLAN related issues they suck down a good 
amount of power when their radio is up, I would definitely suggest 
monitoring with a 'scope the various rails (Vcore, RAM and whatever it 
is the CF Card is powered by) while putting it under load.

-Andy
