Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbYHAHZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbYHAHZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYHAHYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:24:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49156 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYHAHYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:24:52 -0400
Date: Fri, 01 Aug 2008 16:23:40 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Cc: kosaki.motohiro@jp.fujitsu.com, halesh.s@india.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080731143032.2a211c18.akpm@linux-foundation.org>
References: <20080731211811.3CA9.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080731143032.2a211c18.akpm@linux-foundation.org>
Message-Id: <20080801161651.FEBE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> I assume that you tested it too?

Yes, my x86_64 box works well.

sorry, ambiguity e-mail.

halesh's test check two point.
  - mlock rlimit
  - invlid address range

and, I think rlimit already works well.
So, I ask halesh re-confirming.

> If it comes down to a choice between complying with SuS versus
> complying with earlier Linux versions then we'd usually prefer to
> comply with earlier Linux versions.

I see.

> I queued this, but would prefer to await confirmation that it has been
> tested to take us back to the 2.6.18 interface, please.

Yes.
this patch wasn't tested on split-lru yet.
I'll do that. (and probably fix it)

> Also, please send a Signed-off-by: for this change.

Agghh, sorry. it is stupid forgotten.



