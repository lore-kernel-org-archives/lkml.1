Return-Path: <linux-kernel-owner+w=401wt.eu-S1765457AbXGPOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765457AbXGPOXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbXGPOXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:23:07 -0400
Received: from [212.12.190.75] ([212.12.190.75]:32937 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759782AbXGPOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:23:06 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
Date: Mon, 16 Jul 2007 17:22:53 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707161722.53203.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Or just "cp -al" to create multiple trees at (almost) no disk cost
> that won't interfere with each other in any way, and makes the
> development process / generating patchsets trifle easier as well ...

That would be correct if hardlinks would actually do a CoW on modify, instead 
of misleading the user into thinking he is modifying an independent file.

Moral of the story:  try to avoid hardlinks as much as possible!


Thanks!

--
Al

