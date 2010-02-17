Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab0BQJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:57:25 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:44206 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab0BQJ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:57:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N9+XqPh5zkFxk89/epkRn5C3sCJiykytx5hgt0I99fG3X+PfWDTU9jy9PauVUgVdbS
         HIQcItJYVQOFcM4282mx3xv2GEQJOA/pez7i2XPWVK6mCqRrsFlL4JQbKeYZRfsx8Zki
         qcepc5JIZtKO90DEUOsmvkZF+XJf/3cKxccDI=
Message-ID: <4B7BBD7D.9090602@warmcat.com>
Date: Wed, 17 Feb 2010 10:57:17 +0100
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
References: <20100208065519.GE1290@ucw.cz> <1265622676.4020.19.camel@pc1117.cambridge.arm.com> <4B6FE162.6000004@warmcat.com> <20100217095000.GA17643@pengutronix.de>
In-Reply-To: <20100217095000.GA17643@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/10 10:50, Somebody in the thread at some point said:
> On Mon, Feb 08, 2010 at 11:03:14AM +0100, Andy Green wrote:
>> On 02/08/10 10:51, Somebody in the thread at some point said:
>>
>>> We could of course flush the caches every time we get a page fault but
>>> that's far from optimal, especially since DMA-capable drivers to do not
>>> pollute the D-cache and don't need this extra flushing. Note that the
>>> recent ARM processors have PIPT caches but separate for I and D and it's
>>> the PIO drivers that pollute the D-cache.
>>
>> Just noting that AFAIK iMX31 USB and MMC drivers both are PIO at the
>> moment, for lack of any platform DMA support of its unusual DMA engine.
>
> The EHCI module has its own DMA engine and has nothing to do with the
> SDMA engine.

You're right, my mistake.  iMX31 MMC is PIO due to no SDMA support though.

-Andy
