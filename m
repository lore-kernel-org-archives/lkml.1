Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0BHKDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:03:19 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36830 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0BHKDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ki5g4NQC6XkVsSlu+MnXoOiDupKUe6Oik+8oWzytryb64+yBSChn6jBGaXKza47zOJ
         iRy8YYglUFaZ1/FPry6xXsMhqt6DLQVZcJ/MLMMp9elxC83UAzJNv3rcdWAtvKavWXqg
         Y8TPgR6Pm5T8qI1HyUG28yaaM9gk3uH3UZbGY=
Message-ID: <4B6FE162.6000004@warmcat.com>
Date: Mon, 08 Feb 2010 11:03:14 +0100
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Pavel Machek <pavel@ucw.cz>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: USB mass storage and ARM cache coherency
References: <20100208065519.GE1290@ucw.cz> <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1265622676.4020.19.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/10 10:51, Somebody in the thread at some point said:

> We could of course flush the caches every time we get a page fault but
> that's far from optimal, especially since DMA-capable drivers to do not
> pollute the D-cache and don't need this extra flushing. Note that the
> recent ARM processors have PIPT caches but separate for I and D and it's
> the PIO drivers that pollute the D-cache.

Just noting that AFAIK iMX31 USB and MMC drivers both are PIO at the 
moment, for lack of any platform DMA support of its unusual DMA engine.

-Andy
