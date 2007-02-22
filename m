Return-Path: <linux-kernel-owner+w=401wt.eu-S965155AbXBVBaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155AbXBVBaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 20:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXBVBaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 20:30:20 -0500
Received: from gw.goop.org ([64.81.55.164]:48448 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965155AbXBVBaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 20:30:20 -0500
Message-ID: <45DCF1C5.4030006@goop.org>
Date: Wed, 21 Feb 2007 17:28:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: -freg-struct-return?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have a number of functions which return small structures (such as
pte_t).  It seems that the kernel is not compiled with
-freg-struct-return, so all these small structures are being returned
via the stack, even though they would fit into registers.

Is there a reason for this?  Would -freg-struct-return be preferred?  It
would make a good compliment to -mregparm.

    J
