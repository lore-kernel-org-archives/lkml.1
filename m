Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbYEWUzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbYEWUzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 16:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYEWUza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 16:55:30 -0400
Received: from gw.goop.org ([64.81.55.164]:40018 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbYEWUz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 16:55:29 -0400
Message-ID: <48372F22.2050708@goop.org>
Date: Fri, 23 May 2008 21:54:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: SMP support
References: <20080523141759.GA1833@damson.getinternet.no>	 <4836E55C.5000304@goop.org>	 <19f34abd0805230851w59a5972dk593900cf3ea8c14a@mail.gmail.com>	 <4836FB0B.9020906@web.de> <19f34abd0805231032h2055c092h6423638cb69ca5c9@mail.gmail.com>
In-Reply-To: <19f34abd0805231032h2055c092h6423638cb69ca5c9@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hm. Doesn't KVM require special hardware? I have just a cheap laptop
> (Pentium Dual-Core) and I doubt I will be able to run it... :-(
>   

If you have an Intel dual-core CPU from the last couple of years, it 
almost certainly has the VT capability (look for "vmx" in 
/proc/cpuinfo).  It may not be usable unless the BIOS enables it though...

    J
