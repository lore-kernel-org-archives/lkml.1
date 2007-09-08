Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIHBQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIHBQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 21:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXIHBQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 21:16:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXIHBQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 21:16:38 -0400
To: linux-kernel@vger.kernel.org
Subject: PPC64 AT_IGNOREPPC question
From: Vitaly Mayatskikh <vmayatsk@redhat.com>
Date: Sat, 08 Sep 2007 03:15:25 +0200
Message-ID: <m3odgehs9e.fsf@dhcp-lab-156.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


include/asm-powerpc/elf.h:289

Why we need the second AT_IGNOREPPC entry here?

There is a mm_struct->saved_auxv overflow on PPC64 with AT_VECTOR_SIZE
== 44 (may be on PPC32 too, not checked) when adding all entries to
it. I've removed the second AT_IGNOREPCC from ARCH_DLINFO to prevent 
overflowing, checked it on IBM OpenPower 720 and a system (Fedora 7) is 
going on as well. Have I missed some tricky thing?
