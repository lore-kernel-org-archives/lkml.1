Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXEVTbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXEVTbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXEVTbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:31:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:55090 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXEVTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ijxymAO/LGqlYCX5hbRJRvRPR1eypaa8PTYl2fMYBQz8K2JgajpLrjIdFKBnWrWjSV2UHnYyHG7xQuw89NO99BymjvIIKCM8a3p2+49E2FdEoq+bmNsRkAn+qIFp5GJKgkrCHmRnSJAWj5DgU5nzonCHkxPKagFdt++XxSd5swA=
Date: Tue, 22 May 2007 21:31:49 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jimmy Jazz <Jimmy.Jazz@gmx.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: radeonfb and X800 cards
Message-ID: <20070522193149.GA15040@dreamland.darkstar.lan>
References: <464BB43D.2020407@gentoo.org> <1179367164.32247.256.camel@localhost.localdomain> <20070517195958.GA6489@dreamland.darkstar.lan> <1179451140.32247.326.camel@localhost.localdomain> <465044FC.30204@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465044FC.30204@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Sun, May 20, 2007 at 02:54:20PM +0200, Jimmy Jazz ha scritto: 
> @Luca, if i remember well you have a X850, could you please try the
> patch for me ?

It does work - sort of; BIOS parsing code is correct. It lacks the
proper connector detection though (esp. port sharing). ATOM BIOS has a
different data layout, so this should be added (now radeonfb thinks that
I've 2 monitors).

I'll be away this weekend, so I'll try to come up with a patch as soon
as I return home.

Luca
-- 
"L'abilita` politica e` l'abilita` di prevedere quello che
 accadra` domani, la prossima settimana, il prossimo mese e
 l'anno prossimo. E di essere cosi` abili, piu` tardi,
 da spiegare  perche' non e` accaduto."
