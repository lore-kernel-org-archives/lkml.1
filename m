Return-Path: <linux-kernel-owner+w=401wt.eu-S932682AbYBUNOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbYBUNOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932071AbYBUNOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:14:35 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:50388 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764966AbYBUNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DSdcC40DoEdwHca14Vq/K8vAN4yaS1Sgg/P1uFmlYlHnVJqCjoPXhrsWUNEvNYq01gwVb/ipOTvKURM98B9E/qUIa26nHfJGq+QD6u5QJoyVtVvp62Gl9ZvIh69fbJtcsfxwzNpkp5a0KFficvCPZdz/btQVOtUAn850VVb9xBo=
Message-ID: <47BD7958.5080203@gmail.com>
Date: Thu, 21 Feb 2008 14:15:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>
CC: Arjan van de Ven <arjan@infradead.org>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: getting uninterruptible sleep processes after upgrade from 2.6.20.20
 to 2.6.24.2
References: <47B892B9.7060205@allied-internet.ag>	<alpine.DEB.1.00.0802172133470.6469@sheep.housecafe.de>	<47B89DC6.4070906@allied-internet.ag> <20080217125407.5b76a052@laptopd505.fenrus.org> <47BD5B30.103@allied-internet.ag>
In-Reply-To: <47BD5B30.103@allied-internet.ag>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Priebe - allied internet ag napsal(a):
> Hello!
> 
> I've done the (echo t > /proc/sysrq-trigger) now but i'm not able to get
> the whole output via dmesg.
> 
> Here is what i get:
> # dmesg
> 3.432124]  [<c0165a11>] do_select+0x390/0x46e
> [272363.432226]  [<c0166107>] __pollwait+0x0/0xcf
> [272363.432319]  [<c0115d90>] default_wake_function+0x0/0x8

dmesg ring buffer is too small to fit this in. Please repeat it once again
with bigger ringbuffer (dmesg -s if you have this chosen in your kernel) or
post /var/log/meassages output of all processes. I see only waiters in
readdir, not seeing who could block them.

Which filesystem did you run du on?
