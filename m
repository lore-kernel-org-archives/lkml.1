Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbZCWO6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbZCWO6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCWO55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:57:57 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:42273 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZCWO55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:57:57 -0400
Message-ID: <49C7A370.9070601@grupopie.com>
Date: Mon, 23 Mar 2009 14:57:52 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCker?= <m.bueker@berlin.de>
CC: Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com> <200903231529.18064.m.bueker@berlin.de>
In-Reply-To: <200903231529.18064.m.bueker@berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Büker wrote:
> On Sunday 22 March 2009, Francois Romieu wrote:
>   
> I have not tried your patches, but I'd like to point out that I can also 
> reproduce this error with a card that uses the 8139too driver, so it seems 
> unlikely to me that the root of it all lies in the r8169 code.
>
> Please don't be annoyed if this comment is utterly unqualified, it just seems 
> like a point that should be made :)
>   
There are also a few other notes that should be taken into
consideration, witch I already mentioned:
1) I have 3 other NIC's on the same machine that also use r8169 driver.
I cannot reproduce this problem in any of them. These are PCI cards.
2) The card on which I can reproduce this problem is a PCI Express one (
on board ).
3) If I compile the kernel without MSI/MSI-X support, I can't also
reproduce the problem. You may test it by booting with pci=nomsi

I believe that Francoi's patches (correct me if I'm wrong), are meant
for him just be sure/clue on where the problem lies. I'll test those
patches in a few hours and will report back the results.

> Michael
>
>   

-- 
Regards,
Rui Santos

