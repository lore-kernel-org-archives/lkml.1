Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbYG1PEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbYG1PEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYG1PEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:04:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:2288 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752033AbYG1PEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:04:37 -0400
Date: Tue, 29 Jul 2008 00:03:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] binfmt_elf_fdpic: auxvec updates.
Message-ID: <20080728150359.GA16555@linux-sh.org>
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

These depend on the refactored NEW_AUX_ENT(), so against -next or -mm
presently.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   91 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 25 deletions(-)
