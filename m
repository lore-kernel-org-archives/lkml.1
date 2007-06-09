Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbXFIH4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbXFIH4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXFIHzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:55:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:19833 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbXFIHzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:55:53 -0400
Date: Sat, 9 Jun 2007 09:55:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jonathan@jonmasters.org
Subject: Re: Size of kernel modules
In-Reply-To: <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
 <20070608034421.GM26717@fattire.cabal.ca> <Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 08:40, Robert P. J. Day wrote:
>>
>> If you disable CONFIG_DEBUG_KERNEL, things should go back to normal
>> sizes for you.
>
>grow so much compared to *which other modules*?  the ones that came
>with your distro?  if that's the case, try installing your new modules
>with
>
>  # make INSTALL_MOD_STRIP=1 modules_install
>
>that makes a *huge* difference in the size of the installed modules,
>as i learned when i first ran across this on my fedora core system.

Definitely. Running depmod on debug-enabled .ko files explodes in a segfault
after depmod allocates more and more and more memory (exhausting both 
my ram and swap).


	Jan
-- 
