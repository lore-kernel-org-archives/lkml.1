Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbYHFKzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbYHFKzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYHFKzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:55:46 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:29282 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753105AbYHFKzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:55:45 -0400
Date: Wed, 6 Aug 2008 19:34:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] binfmt_elf_fdpic: auxvec updates, v2.
Message-ID: <20080806103458.GE2610@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a tiny series of patches for bringing binfmt_elf_fdpic back in
line with binfmt_elf in terms of auxiliary vector layout, particularly
for the new entries that have popped up recently.

[PATCH 1/3] binfmt_elf_fdpic: Support auxvec base platform string.
[PATCH 2/3] binfmt_elf_fdpic: Convert initial stack alignment to arch_align_stack().
[PATCH 3/3] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN, AT_SECURE.

Changes since the last version include the updated 2/3 patch and a
cosmetic fixup in 1/3.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   89 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 25 deletions(-)
