Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbXLLA3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbXLLA3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXLLA25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:28:57 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4194 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbXLLA24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:28:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=lG2C9eX0WtJ1+j1Ft/b9A46KayaXcwhrlQU7xbPHuYLqs9GJSmZoZeTOrsczcMssw+OVwV1WdoPKc5ajQlYrrQCAb4vyFyTCnYOSIrvUoEstyQ8DsyK+j+OHsUw1VYYfpKqBsoAXaWM3ndJ1k7M6otPG35eOxfXpF2B0knpaVvs=
Message-ID: <475F2AF2.2060206@keyaccess.nl>
Date: Wed, 12 Dec 2007 01:27:30 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <200712120140.34697.maximlevitsky@gmail.com> <475F20EA.5050803@keyaccess.nl> <200712120214.21346.maximlevitsky@gmail.com>
In-Reply-To: <200712120214.21346.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-07 01:14, Maxim Levitsky wrote:

> CPU frequency locked to 2128.000 Mhz:
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1650, in 1065

> CPU frequency locked to: 1596.000 Mhz
> maxim@MAIN:~/tmp$ sudo ./port800
> cycles: out 1730, in 1138

> A bit strange, isn't it?

Well, yes. Don't know what that effect is. A bus-clock divided from the CPU 
clock comes to mind, but I believe that shouldn't happen to LPC.

Anyways, we're looking for an upper bound and that's still nicely below 2 us 
on everything upto now, so I guess it doesn't matter all that much. Thanks!

Rene.
