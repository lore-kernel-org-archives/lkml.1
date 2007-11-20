Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXKTAQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXKTAQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXKTAQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:16:23 -0500
Received: from simmts5-srv.bellnexxia.net ([206.47.199.163]:54714 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXKTAQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:16:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAJe1QUecIs0t/2dsb2JhbAAI
Message-ID: <47422754.9090802@gmail.com>
Date: Mon, 19 Nov 2007 20:16:20 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] Fix missing closing parenthesis in binfmt_elf.c
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


An obviously missing closing parenthesis.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

---

This is more for practice sending patches than anything else, to make
sure they are not damaged in any way.

But it does bring up a good question.  Are patches expected/wanted for
the mmotm kernels?

Index: linux-mm/fs/binfmt_elf.c
===================================================================
--- linux-mm.orig/fs/binfmt_elf.c       2007-11-19 20:01:00.000000000 -0400
+++ linux-mm/fs/binfmt_elf.c    2007-11-19 20:02:34.000000000 -0400
@@ -1031,7 +1031,7 @@
        }

        if (elf_interpreter) {
-               if (IS_AOUT_INTERP(interpreter_type) {
+               if (IS_AOUT_INTERP(interpreter_type)) {
                        elf_entry = load_aout_interp(&loc->interp_ex,
                                                     interpreter);
                } else {
