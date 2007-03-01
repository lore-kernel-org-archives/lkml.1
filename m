Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXCARFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXCARFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965410AbXCARFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:05:07 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:37052 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400AbXCARFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:05:06 -0500
Message-ID: <45E7071C.6030103@f2s.com>
Date: Thu, 01 Mar 2007 17:02:20 +0000
From: Ian Molton <spyro@f2s.com>
Organization: The Dragon Roost
User-Agent: Thunderbird 2.0a1 (X11/20061107)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] udivdi3: 64 bit divide
References: <20070226173517.66bf0fec@freekitty> <20070227122437.da27c3cd.akpm@linux-foundation.org> <20070227131840.672d6932@localhost> <20070227133656.c452fbb4.akpm@linux-foundation.org> <20070227222430.GC10380@flint.arm.linux.org.uk> <45E4B33D.8080705@f2s.com> <Pine.LNX.4.61.0702282327410.23355@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702282327410.23355@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> The non-arch specific code does not use 64/64
> divides through the "/" operator (otherwise there would
> already have been udivdi3 linking errors). So what
> remains to check is arch/arm26. grep -Pr 'int64|\bu64'
> returns only a few results to check (kernel/ecard.c,
> nwfpe/), so the answer is most likely no.

Looks that way. ok, nuke it :)
