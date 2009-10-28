Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZJ1DpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZJ1DpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbZJ1DpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:45:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47789
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687AbZJ1DpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:45:07 -0400
Date: Tue, 27 Oct 2009 20:45:30 -0700 (PDT)
Message-Id: <20091027.204530.142024242.davem@davemloft.net>
To: airlied@linux.ie
Cc: airlied@gmail.com, andi@firstfloor.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie>
References: <21d7e9970910272005mbb268r7b16493a22ca275a@mail.gmail.com>
	<20091027.203838.21218679.davem@davemloft.net>
	<alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>
Date: Wed, 28 Oct 2009 03:43:07 +0000 (GMT)

> we already opencoded this (probably before it was macroisied or we just 
> pasted it), so the radeon one is buggy, I should just go and compat_* all 
> of these then and we should be all happy?

It should be, it's only working because:

1) A malicious userland hasn't put garbage in the upper bits for
   you yet.

2) Nobody has tested s390 yet :-)

Let's just not design non-portability into the code when we
have no strong reason to, ok? :-)
