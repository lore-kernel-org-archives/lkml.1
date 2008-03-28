Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbYC1AzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbYC1AzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbYC1Ay5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:54:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753609AbYC1Ay4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:54:56 -0400
Date: Thu, 27 Mar 2008 17:54:56 -0700 (PDT)
Message-Id: <20080327.175456.70727997.davem@davemloft.net>
To: ilpo.jarvinen@helsinki.fi
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH 0/7]: uninline some net related static inline in .h
 bloaters
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ilpo_Järvinen" <ilpo.jarvinen@helsinki.fi>
Date: Thu, 27 Mar 2008 14:37:59 +0200

> As suggested by Andrew, I rerun the uninlining of all what's in .h
> (v2.6.25-rc2-mm1 this time) to fix the (un)likely profiling overhead
> which showed up in the allyesconfig results. The config was manually
> tweaked from allyesconfig to not include a number of debug related
> options [1]. Other setup: 32-bit x86, gcc (GCC) 4.1.2 20070626
> (Red Hat 4.1.2-13). I also tweaked the uninlining machinery a bit and
> got even better coverage than last time.

I applied everything and will push to net-2.6.26 after some
build tests.

Thanks!
