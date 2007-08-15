Return-Path: <linux-kernel-owner+w=401wt.eu-S936712AbXHOVJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936712AbXHOVJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760606AbXHOVJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:09:23 -0400
Received: from flpi101.sbcis.sbc.com ([207.115.20.70]:14226 "EHLO
	flpi101.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbXHOVJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:09:22 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 17:09:22 EDT
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH] Fix the sign of the result of a conditional expression
To: andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2007 17:02:41 -0400
Message-ID: <20070815204939.3518.63203.stgit@monet.1015granger.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In include/asm-x86_64/bitops.h, the find_{first,next,first_zero,next_zero}_bit
macros return a result type that depends on the width of the "size" argument.
The type of both arms of a conditional expression should always be the same.

I changed the return type of __scanbit() to match the return type of the
x86_64 find_*_bit() functions.

-- 
corporate:    <chuck dot lever at oracle dot com>
