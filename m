Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXBMKR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXBMKR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXBMKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:17:58 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:59859 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbXBMKR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:17:57 -0500
Date: Tue, 13 Feb 2007 11:16:56 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Menny Hamburger <menny@exanet.com>, linux-kernel@vger.kernel.org
Subject: Re: ARP hidden patch vs. arp ignore/announce
In-Reply-To: <1171356740.12771.54.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.61.0702131116070.31448@yvahk01.tjqt.qr>
References: <A6FDE6B975803043804A49F12F49028E0F5757@hawk.exanet-il.co.il>
 <1171356740.12771.54.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13 2007 09:52, Arjan van de Ven wrote:
>
>> If there is currently no way to provide this functionality using
>> arp_ignore/arp_annonce/arp_filter or their friends, why is this still a
>> patch
>> And is not integrated into the mainline kernel?
>
>eh? if you keep reading the doc it'll explain that there is arptables in
>the current kernels, which is like iptables for arp, and you can do very
>finegrained control with that, including the ignore stuff...
>

One thing remains, arptables can't do ebtables's -j arpreply. (That would have
been too great - I could get rid of the extra br0 interface!)


Jan
-- 
