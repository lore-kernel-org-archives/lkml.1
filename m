Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbZLaF72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbZLaF72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 00:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZLaF71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 00:59:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37352
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbZLaF71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 00:59:27 -0500
Date: Wed, 30 Dec 2009 21:59:26 -0800 (PST)
Message-Id: <20091230.215926.226788191.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, tom@opengridcomputing.com
Subject: Re: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F533@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F533@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Tue, 29 Dec 2009 11:22:42 -0500

> Use the %pM kernel extension to display the MAC address.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Hartley, I was going to mention this for your previous
series, and now that you've sent another huge set of
patches I must make a note of this.

Every single one of your patches applies with one-line of
patch 'fuzz', like this:

davem@sunset:~/src/GIT/linux-2.6$ patch -p1 <diff
patching file drivers/infiniband/hw/amso1100/c2_provider.c
Hunk #1 succeeded at 760 with fuzz 1.

And GIT rejects such patches entirely:

davem@sunset:~/src/GIT/linux-2.6$ git apply --check --whitespace=error-all diff
error: patch failed: drivers/infiniband/hw/amso1100/c2_provider.c:760
error: drivers/infiniband/hw/amso1100/c2_provider.c: patch does not apply

So I had to add all of your patches to my tree by hand, one by one,
yesterday.

I refuse to do this for so many more patches.  Could you generate
patches that apply accurately?

Thanks.
