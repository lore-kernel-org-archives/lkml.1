Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbYHHXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbYHHXRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 19:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYHHXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 19:17:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44499
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbYHHXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 19:17:27 -0400
Date: Fri, 08 Aug 2008 16:17:28 -0700 (PDT)
Message-Id: <20080808.161728.186692077.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: mikpe@it.uu.se, kernel-testers@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc: SPARC: Sun Ultra 10 can not boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670808080452u2833418agc8027dfc33c9bb18@mail.gmail.com>
References: <a4423d670808080356r6573102am8a1eb9dcc83910c8@mail.gmail.com>
	<20080808.041814.41687650.davem@davemloft.net>
	<a4423d670808080452u2833418agc8027dfc33c9bb18@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Fri, 8 Aug 2008 15:52:53 +0400

> Now I see call trace:
> __free_pages_ok
> __free_pages
> __free_pages_bootmem
> free_all_bootmem_core
> free_all_bootmem
> mem_init
> start_kernel
> tlb_fixup_done
> 
> Can it be helpful?

This is probably a different bug than the one I fixed, we'll have
to analyze this somehow.

I'll cook up a patch that will let you see the crash without it
scrolling off the screen.
