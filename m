Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYHSPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYHSPdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYHSPdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:33:01 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:56501 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbYHSPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:33:00 -0400
Message-ID: <48AAE7A5.9000902@cetrtapot.si>
Date: Tue, 19 Aug 2008 17:32:53 +0200
From: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: Phil Oester <kernel@linuxace.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iptables-1.4.0 with 2.6.26
References: <48AAAFEB.8020608@cetrtapot.si> <20080819140601.GA5135@linuxace.com> <48AAD48E.3030409@cetrtapot.si> <20080819152504.GA13246@linuxace.com>
In-Reply-To: <20080819152504.GA13246@linuxace.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Oester wrote:
> On Tue, Aug 19, 2008 at 04:11:26PM +0200, Hinko Kocevar wrote:
>> Well, it builds.
>> But trying to add simple rule fails:
>>
>> hinkok@alala /tmp/iptables-1.4.1.1 $ sudo ./iptables -A INPUT -p tcp --dport 80 -j DROP
>> iptables v1.4.1.1: Unknown arg `--dport'
>> Try `iptables -h' or 'iptables --help' for more information.
> 
> Yes, that wouldn't work unless you built a static iptables binary (--enable-static).

Tried and it works, with forcing symlink on iptables-static.
hinkok@alala /tmp/iptables-1.4.1.1 $ rm iptables
hinkok@alala /tmp/iptables-1.4.1.1 $ ln -s iptables-static iptables
hinkok@alala /tmp/iptables-1.4.1.1 $ sudo ./iptables -A INPUT -p tcp --dport 80 -j DROP
hinkok@alala /tmp/iptables-1.4.1.1 $ 

> Please run make install, then it will work for you from the install directory.

Will this be a problem on an embedded system, when iptables are cross compiled? 
Are there some cynimic libraries that are pulled in from somewhere (probably destdir installation dir)?

Thank you,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

