Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXHVH4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXHVH4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 03:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXHVH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 03:56:14 -0400
Received: from wenus.cyberbajt.pl ([195.205.217.180]:59823 "EHLO
	wenus.cyberbajt.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbXHVH4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 03:56:14 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 03:56:12 EDT
Date: Wed, 22 Aug 2007 09:49:15 +0200
From: =?UTF-8?B?UmFmYcWC?= Maj <forlist@limcore.com>
To: linux-kernel@vger.kernel.org
Subject: Calling BIOS interrupt from kernel (and debugging / reverse
 engeneering)
Message-ID: <20070822094915.41afa2af@lore.lcone>
Organization: LimCore.com
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
I know it is not good to call BIOS interrupt from Linux (kernel nor
userspace) and we should use I/O ports instead;

But, is it at all doable? To call a BIOS interrupt from Linux kernel?

If so then how to?

In example, say we have not documented device returning data in AL
after call to interrupt 0x15 with AX=0x1234 for example; And we want to
use this BIOS interrupt and then printk() returned value in AL.

AFAIK vm86() is one step to do it, but its hard to find good complete
example at least for me.

Btw, is it possible to reverse engineering such a BIOS call? Besides
using some hardware-debugger of bus etc.

Thanks










