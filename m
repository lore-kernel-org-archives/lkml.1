Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGFLlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGFLlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbXGFLkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:40:53 -0400
Received: from mail.macqel.be ([194.78.208.39]:11859 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbXGFLkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:40:53 -0400
Date: Fri, 6 Jul 2007 13:40:49 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] m68knommu : make cpuinfo_op const
Message-ID: <20070706114049.GA12735@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Make m68knommu cpuinfo_op const.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 6c0a10cc415a arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c	Thu Jul  5 16:10:16 2007 -0700
+++ b/arch/m68knommu/kernel/setup.c	Fri Jul  6 13:37:57 2007 +0200
@@ -313,7 +313,7 @@ static void c_stop(struct seq_file *m, v
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
