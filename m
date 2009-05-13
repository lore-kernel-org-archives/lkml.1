Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbZEMXR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbZEMXR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbZEMXRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:17:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53542 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbZEMXRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:17:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Kconfig: CONFIG_UNEVICTABLE_LRU move into EMBEDDED submenu
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Minchan@firstfloor.org
In-Reply-To: <20090513141335.GS19296@one.firstfloor.org>
References: <2f11576a0905130458x2e56e952ga47216da42b30906@mail.gmail.com> <20090513141335.GS19296@one.firstfloor.org>
Message-Id: <20090514080200.1E24.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 08:17:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 1. this featuren don't depend CONFIG_MMU. that's bogus.
> 
> Without CONFIG_MMU everything is unevictable, so you don't need
> to special case unevictable pages.  Or are you saying it should
> use this code always?

Ah, I misparsed your messages.
I talked as the code is independent, but you talked worth is little.
hm, I think both are right.

Anyway, Minchan acked to remvoe config option, I'll do that.
Thanks.




