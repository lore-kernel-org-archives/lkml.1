Return-Path: <linux-kernel-owner+w=401wt.eu-S932665AbYBBAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbYBBAdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763536AbYBBAZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:55838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763169AbYBBAZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:37 -0500
Date: Fri, 1 Feb 2008 16:21:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ilpo J????rvinen <ilpo.jarvinen@helsinki.fi>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 26/27] POWERPC: Fix invalid semicolon after if statement
Message-ID: <20080202002114.GA8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="powerpc-fix-invalid-semicolon-after-if-statement.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>

Patch 2b02d13996fe28478e45605de9bd8bdca25718de in mainline

[POWERPC] Fix invalid semicolon after if statement

A similar fix to netfilter from Eric Dumazet inspired me to
look around a bit by using some grep/sed stuff as looking for
this kind of bugs seemed easy to automate.  This is one of them
I found where it looks like this semicolon is not valid.

Signed-off-by: Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/hash_utils_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -795,7 +795,7 @@ void hash_preload(struct mm_struct *mm, 
 
 #ifdef CONFIG_PPC_MM_SLICES
 	/* We only prefault standard pages for now */
-	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize));
+	if (unlikely(get_slice_psize(mm, ea) != mm->context.user_psize))
 		return;
 #endif
 

-- 
