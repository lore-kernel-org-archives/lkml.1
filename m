Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbZLEOuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbZLEOuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:50:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZLEOuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:50:04 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:44010 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZLEOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:49:54 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2009 09:49:54 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TNOWbFbMv1V9JcrE1axmMfyCPBR1dynDH1WQDJAlIz5HQt9CDwW+6iHBswX8JCHErb
         oy32GOy952XmHoB1wwespfe8N9mcGHsHNiBKtW6tj3CV8LpCTp/5bdjo1Abnm3cmD7Uy
         xFwSKiHuOwfrX7Hb1+40m18esxWW2dFm3exws=
Subject: Re: [PATCH] Spelling in in /arch/x86/mm
From: Shaun Patterson <shaunpatterson@gmail.com>
Reply-To: shaunpatterson@gmail.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, pq@iki.fi, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20091205071822.GC25383@elte.hu>
References: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com>
	 <20091204070008.GA9761@elte.hu>
	 <alpine.LNX.2.00.0912041340380.3755@pobox.suse.cz>
	 <20091205071822.GC25383@elte.hu>
Content-Type: text/plain
Date: Sat, 05 Dec 2009 10:41:34 -0500
Message-Id: <1260027694.10074.170.camel@linux-4lgc.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can fix that - not the garbled-beyond-recognition patch though

Sorry about that.  Try this.


Signed-off-by: Shaun Patterson <shaunpatterson@gmail.com>
---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 16ccbd7..72f1572 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
  * 2. remove_kmmio_fault_pages()
  *    Remove the pages from kmmio_page_table.
  * 3. rcu_free_kmmio_fault_pages()
- *    Actally free the kmmio_fault_page structs as with RCU.
+ *    Actually free the kmmio_fault_page structs as with RCU.
  */
 void unregister_kmmio_probe(struct kmmio_probe *p)
 {


