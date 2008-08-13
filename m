Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYHMQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYHMQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYHMQMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:12:43 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:57239
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447AbYHMQMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:12:42 -0400
Date: Wed, 13 Aug 2008 12:12:42 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] vmlinux.strip should be ignored
Message-ID: <20080813121242.1466551d@lappy.seanm.ca>
Organization: PIKA
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new output file vmlinux.strip is created, at least on the powerpc
arch, and should be ignored by git.

Cheers,
   Sean

Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
---
diff --git a/.gitignore b/.gitignore
index 869e1a3..f7e924a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,6 +32,7 @@
 tags
 TAGS
 vmlinux
+vmlinux.strip
 System.map
 Module.markers
 Module.symvers
