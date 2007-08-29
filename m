Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXH2I3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXH2I3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 04:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbXH2I3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 04:29:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42359
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbXH2I3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 04:29:19 -0400
Date: Wed, 29 Aug 2007 01:29:16 -0700 (PDT)
Message-Id: <20070829.012916.02298847.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <46D51BD7.6040904@de.ibm.com>
References: <200708281319.03903.ossthema@de.ibm.com>
	<20070828.132152.38706038.davem@davemloft.net>
	<46D51BD7.6040904@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Wed, 29 Aug 2007 09:10:15 +0200

> In the end I want to reduce the CPU utilization. And one way
> to do that is LRO which also works only well if there are more
> then just a very few packets to aggregate. So at least our
> driver (eHEA) would benefit from a mix of timer based polling
> and plain NAPI (depending on load situations).
> 
> If there is no need for a generic mechanism for this kind of
> network adapters, then we can just leave this to each device
> driver.

No objections from me either way, if something works then
fine.

Let's come back to this once you have a tested sample implementation
that does what you want, ok?
