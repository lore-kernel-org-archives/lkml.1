Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXKVXwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXKVXwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 18:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXKVXv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 18:51:57 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40429 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXKVXv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 18:51:57 -0500
Date: Thu, 22 Nov 2007 18:51:41 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: uml doesn't work on 2.6.24-rc2
Message-ID: <20071122235141.GA7876@c2.user-mode-linux.org>
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu> <20071114173639.GA7899@c2.user-mode-linux.org> <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu> <20071116170630.GA9299@c2.user-mode-linux.org> <E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IvGTn-0007cC-7q@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2007 at 07:08:47PM +0100, Miklos Szeredi wrote:
> Thanks.  My other problem is (probably you are aware) that recent -mm
> kernels don't compile for UML.

The patch below fixes the build for rc3-mm1 for me.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/include/asm-um/asm.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22/include/asm-um/asm.h	2007-11-21 12:15:03.000000000 -0500
@@ -0,0 +1,6 @@
+#ifndef __UM_ASM_H
+#define __UM_ASM_H
+
+#include "asm/arch/asm.h"
+
+#endif
