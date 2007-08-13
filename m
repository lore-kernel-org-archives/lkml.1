Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbXHMFJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbXHMFJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbXHMFI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:08:56 -0400
Received: from [212.12.190.150] ([212.12.190.150]:32834 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752595AbXHMFI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:08:56 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: How to make -mm a more viable testbed (was: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD)
Date: Mon, 13 Aug 2007 08:08:46 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130808.46989.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sun, 12 Aug 2007, Dave Jones wrote:
> > 
> > This does make me wonder, why these weren't caught in -mm ?
> 
> I'm worried that -mm isn't getting a lot of exposure these days. People do 
> run it, but I wonder how many..

Well, I'm not running it because it's got too much garbage in it, which makes 
it a pretty unrealistic testbed.  And to make matters worse, I also stay 
away from rc's as a consequence.

To make -mm more viable, it may be advisable to restructure -mm in such a way 
as to be a Kconfig option to mainline.  This would probably involve some 
patch management functionality to apply experimental submissions on a 
per-patch basis, as opposed to being a 'take it or leave it slam onto 
mainline' patch.


Thanks!

--
Al

