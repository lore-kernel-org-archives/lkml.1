Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZC3Lu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZC3Lu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZC3LuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:50:16 -0400
Received: from monster.nessie.de ([84.200.20.120]:37834 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZC3LuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:50:15 -0400
Message-ID: <49D0B1F3.7020706@nessie.de>
Date: Mon, 30 Mar 2009 13:50:11 +0200
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: petkovbb@gmail.com, Michael Roth <mroth@nessie.de>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
 workaround
References: <49CFCB2A.4020505@nessie.de> <20090329201337.GA9962@liondog.tnic> <49CFEA24.10700@nessie.de> <20090330072713.GA13776@liondog.tnic> <49D0AF2E.9040006@nessie.de>
In-Reply-To: <49D0AF2E.9040006@nessie.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> b.) unpatched 2.6.29, boot without a medium in an drive
>     but _not_ starting /usr/sbin/hald result in _no_ freeze!
> 
> I can also mount DVDs and access them, with an unpatched kernel
> without started /usr/sbin/hald, without any problems, as far
> as I can see.

c.) I unmounted the DVD, started /usr/sbin/hald and it took
    about 40 seconds until the kernel freeze.

So far as I see, /usr/sbin/hald somehow triggers a bug. But the bug
isn't triggered, when the dma is started after the command is sent.


Michael Roth


