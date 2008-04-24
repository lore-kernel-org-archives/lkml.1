Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYDXJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYDXJYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYDXJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:24:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58474
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYDXJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:24:08 -0400
Date: Thu, 24 Apr 2008 02:24:04 -0700 (PDT)
Message-Id: <20080424.022404.151729194.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: mingo@elte.hu, benh@ozlabs.org, linuxppc-dev@ozlabs.org, arndb@de.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: cpu_clock confusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209028912.3357.52.camel@johannes.berg>
References: <1207240450.3797.22.camel@johannes.berg>
	<20080404144641.GA15844@elte.hu>
	<1209028912.3357.52.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 24 Apr 2008 11:21:52 +0200

> Hmm. Why is that whole cpu_clock stuff in place anyway? powerpc has
> perfectly synchronised time across processors with dirt cheap access to
> it as well, so why build all this code that only messes it up on top of
> it?

Same on sparc64.  These changes add more bugs than they fix.
