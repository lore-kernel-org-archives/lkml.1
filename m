Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZBFGBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZBFGBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZBFGBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:01:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:48464 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbZBFGBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:01:30 -0500
Subject: Re: [Bug #12608] 2.6.29-rc powerpc G5 Xorg legacy_mem regression
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Hugh Dickins <hugh@veritas.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <21d7e9970902051345h76fb26c1hc0397f6262f70eae@mail.gmail.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.sIE.wuYiJB@chimera> <1233791329.4612.23.camel@pasglop>
	 <Pine.LNX.4.64.0902051713550.1445@blonde.anvils>
	 <1233867944.4612.104.camel@pasglop>
	 <21d7e9970902051345h76fb26c1hc0397f6262f70eae@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 17:01:13 +1100
Message-Id: <1233900073.4612.118.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think the correct answer is the ugly one, try again.

Well... it's a fairly recent damage in X which is why I was somewhat
hoping that it wasn't too widespread it couldn't be contained
before the kernel got butchered :-)

But I'll just stick anonymous memory in there instead, it should be
trivial enough.

> Add a new legacy_mem interface that works cleanly, update X to use it,
> leave the old
> broken one broken as it for older X to use.

:-)

Ben.


