Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYKBEmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYKBEmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKBEm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:42:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYKBEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:42:28 -0400
Date: Sat, 01 Nov 2008 21:42:03 -0700 (PDT)
Message-Id: <20081101.214203.39646471.davem@davemloft.net>
To: hugh@veritas.com
Cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.28-rc2: Unable to handle kernel paging request at
 iov_iter_copy_from_user_atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0811011837110.20211@blonde.site>
References: <a4423d670811010723u3b271fcaxa7d3bdb251a8b246@mail.gmail.com>
	<Pine.LNX.4.64.0811011837110.20211@blonde.site>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>
Date: Sat, 1 Nov 2008 18:59:24 +0000 (GMT)

> Alexander Beregalov reports oops in __bzero() called from
> copy_from_user_fixup() called from iov_iter_copy_from_user_atomic(),
> when running dbench on tmpfs on sparc64: its __copy_from_user_inatomic
> and __copy_to_user_inatomic should be avoiding, not calling, the fixups.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

This looks great, applied, thanks Hugh.
