Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYENEjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYENEjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYENEjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:39:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45839
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbYENEjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:39:32 -0400
Date: Tue, 13 May 2008 21:39:27 -0700 (PDT)
Message-Id: <20080513.213927.191790810.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linville@tuxdriver.com,
       ron.rindjunsky@intel.com, sfr@canb.auug.org.au, tomas.winkler@intel.com
Subject: Re: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to
 -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805140405.m4E45oBc015343@imap1.linux-foundation.org>
References: <200805140405.m4E45oBc015343@imap1.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Tue, 13 May 2008 21:05:50 -0700

> Subject: wireless: fix "iwlwifi: unify init driver flow"
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/net/wireless/iwlwifi/iwl-core.c: In function 'iwlcore_init_geos':
> drivers/net/wireless/iwlwifi/iwl-core.c:323: error: implicit declaration of function 'iwlcore_init_ht_hw_capab'
> 
> This (or something like it) should be folded into the base patch to avoid
> breaking bisection, please.
> 
> Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, you have to figure out what we're supposed to do here.

If I "fold in the patch" to avoid breaking bisection, I have to
completely rebase my tree screwing up everyone of my downstream
developers.

Or is this some patch I'm supposed to remember to fold in several
months from now, to some random changeset out of thousands, when the
merge window opens?

Neither option is tenable, and the headaches of neither are
worth it purely for the sake of bisection.

My solution to the bisection problem is to wait a day before pushing
out usually, it's a best effort thing.  I do as many sanity builds as
I can, and we also hope that someone during that day might solve the
problem independantly and post a fix.  That way I can fix it in my
tree locally before the tree goes public.

And I think this is the most reasonable approach.

Once I push something to my public tree, quite frankly, it's the real
deal, it's staying there, and it's a part of the permanent record.
And therefore, we'll put fixes on top.
