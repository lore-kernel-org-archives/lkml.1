Return-Path: <linux-kernel-owner+w=401wt.eu-S935895AbXLQVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895AbXLQVGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbXLQVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:06:08 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:43087 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbXLQVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:06:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=w0//Sj96flACvaRrN1Z/uAVTA9VvKhfviO4TpuXouaA2ZpRmjlSl2tUstqpDbFgy07yMbrxENrP2mgl/KuTMQH+tifn9p1SOnVydWf3vmtif+8L2UX9HqPH7YEi7b9rFYB8GwkLrq2FZXQCJLJdysftil8eQzV8j4KvzctPtlu4=
Message-ID: <4766E453.1030202@keyaccess.nl>
Date: Mon, 17 Dec 2007 22:04:19 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com> <20071214232955.545ab809@the-village.bc.nu>
In-Reply-To: <20071214232955.545ab809@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-12-07 00:29, Alan Cox wrote:

>>> ?? Just initialize bogomips to 6GHz equivalent... and we are fine
>>> until 6GHz cpus come out.
>> How long will that take to boot on a 386?
> 
> Well the dumb approach to fix that would seem to be to initialise it to
> 
> 	cpu->family   3 -> 50MHz 4 -> 300Mhz 5-> etc...

By the way, you have a 300 MHz 486? I believe 3 -> 40, 4 -> 133, 5 -> 233 
would be good? And I'm not really sure about the etc. P6 has a large range 
again...

Rene.
