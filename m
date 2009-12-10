Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZLJBuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZLJBuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbZLJBuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:50:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49215 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759374AbZLJBuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:50:07 -0500
Date: Thu, 10 Dec 2009 02:50:14 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>, Andi Kleen <andi@firstfloor.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [19/31] mm: export stable page flags
Message-ID: <20091210015014.GK18989@one.firstfloor.org>
References: <200912081016.198135742@firstfloor.org> <20091208211635.7965AB151F@basil.firstfloor.org> <1260311251.31323.129.camel@calx> <20091209020042.GA7751@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209020042.GA7751@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry the stable_page_flags() will be undefined on
> !CONFIG_PROC_PAGE_MONITOR (it is almost always on,
> except for some embedded systems).
> 
> Currently the easy solution is to add a Kconfig dependency to
> CONFIG_PROC_PAGE_MONITOR.  When there comes more users (ie. some
> ftrace event), we can then always compile in stable_page_flags().

I decided to turn it into select instead.

Your original patch didn't handle hwpoison as module btw.

-Andi
