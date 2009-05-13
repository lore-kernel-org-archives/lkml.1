Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbZEMOIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbZEMOIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZEMOIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:08:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZEMOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:08:15 -0400
Date: Wed, 13 May 2009 16:13:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Message-ID: <20090513141335.GS19296@one.firstfloor.org>
References: <20090513172904.7234.A69D9226@jp.fujitsu.com> <87r5ytl0nn.fsf@basil.nowhere.org> <2f11576a0905130418w1782f85j12cb938e92d256ff@mail.gmail.com> <20090513113817.GO19296@one.firstfloor.org> <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. this featuren don't depend CONFIG_MMU. that's bogus.

Without CONFIG_MMU everything is unevictable, so you don't need
to special case unevictable pages.  Or are you saying it should
use this code always?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
