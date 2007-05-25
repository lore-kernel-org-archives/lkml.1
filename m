Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbXEYNLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbXEYNLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbXEYNLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:11:04 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:53570 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbXEYNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:11:03 -0400
Message-ID: <4656E054.2060900@hitachi.com>
Date: Fri, 25 May 2007 22:10:44 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, holt@sgi.com, alan@lxorguk.ukuu.org.uk,
       masami.hiramatsu.pt@hitachi.com, yumiko.sugita.yf@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 5/7] ELF-FDPIC: remove an unused argument
References: <4656DBFB.2050501@hitachi.com>
In-Reply-To: <4656DBFB.2050501@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an unused argument from elf_fdpic_dump_segments().

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf_fdpic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc2-mm1/fs/binfmt_elf_fdpic.c
===================================================================
--- linux-2.6.22-rc2-mm1.orig/fs/binfmt_elf_fdpic.c
+++ linux-2.6.22-rc2-mm1/fs/binfmt_elf_fdpic.c
@@ -1456,8 +1456,8 @@ static int elf_dump_thread_status(long s
  * dump the segments for an MMU process
  */
 #ifdef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+static int elf_fdpic_dump_segments(struct file *file, size_t *size,
+				   unsigned long *limit)
 {
 	struct vm_area_struct *vma;
 
@@ -1511,8 +1511,8 @@ end_coredump:
  * dump the segments for a NOMMU process
  */
 #ifndef CONFIG_MMU
-static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
-				   size_t *size, unsigned long *limit)
+static int elf_fdpic_dump_segments(struct file *file, size_t *size,
+				   unsigned long *limit)
 {
 	struct vm_list_struct *vml;
 


