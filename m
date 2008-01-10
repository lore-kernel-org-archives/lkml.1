Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbYAJXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbYAJXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYAJXXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:23:09 -0500
Received: from gw.goop.org ([64.81.55.164]:35214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYAJXXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:23:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 2] x86: a couple of misc patches
Message-Id: <patchbomb.1200004569@localhost>
Date: Thu, 10 Jan 2008 14:36:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

A couple of patches:

1. Fold _PAGE_GLOBAL back into 64-bit __PAGE_KERNEL*, and remove the
MAKE_GLOBAL hack.  Not sure if it will work, but the iounmap problem
should have been fixed by Jan's patch.

2. I noticed the _PAGE_PCD|_PAGE_PWT combination being used a lot, so
I created _PAGE_NOCACHE to wrap them up.  asm-x86/fb.h uses plain
_PAGE_PCD; should it be _PAGE_NOCACHE too?

Thanks,
	J


