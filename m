Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYGZJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYGZJYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYGZJY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:24:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59748
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751642AbYGZJY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:24:28 -0400
Date: Sat, 26 Jul 2008 02:24:27 -0700 (PDT)
Message-Id: <20080726.022427.100320136.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: frank.blaschka@de.ibm.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       braunu@de.ibm.com
Subject: Re: [BUG] qeth doesn't work anymore because of netdev_priv changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725015755.GA5179@osiris.boeblingen.de.ibm.com>
References: <20080724184624.GB8969@osiris.boeblingen.de.ibm.com>
	<20080724.135602.196740386.davem@davemloft.net>
	<20080725015755.GA5179@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Fri, 25 Jul 2008 03:57:55 +0200

> qeth: use dev->ml_priv instead of dev->priv
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This makes qeth working again after git commit
> e3c50d5d25ac09efd9acbe2b2a3e365466de84ed
> "netdev: netdev_priv() can now be sane again.".
> 
> Cc: Ursula Braun <braunu@de.ibm.com>
> Cc: Frank Blaschka <frank.blaschka@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Patch applied, thanks a lot Heiko.
