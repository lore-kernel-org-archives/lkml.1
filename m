Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbYKBEn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbYKBEn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 00:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKBEnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 00:43:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42557
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbYKBEnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 00:43:19 -0400
Date: Sat, 01 Nov 2008 21:42:54 -0700 (PDT)
Message-Id: <20081101.214254.178222451.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.28-rc2: Unable to handle kernel paging request at
 iov_iter_copy_from_user_atomic
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670811012102m3fdd245apbe0a310b4890f958@mail.gmail.com>
References: <a4423d670811010723u3b271fcaxa7d3bdb251a8b246@mail.gmail.com>
	<Pine.LNX.4.64.0811011837110.20211@blonde.site>
	<a4423d670811012102m3fdd245apbe0a310b4890f958@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Alexander Beregalov" <a.beregalov@gmail.com>
Date: Sun, 2 Nov 2008 07:02:40 +0300

> Should we fix also sparc32?

Sparc32 uses a different scheme for all of this stuff.
I don't think your patch will even compile.
