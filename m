Return-Path: <linux-kernel-owner+w=401wt.eu-S967232AbXG3Tub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967232AbXG3Tub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938665AbXG3TuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:50:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935879AbXG3TuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:50:21 -0400
Date: Mon, 30 Jul 2007 12:51:54 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: vdso.lds in arch/x86_64/vdso/.gitignore
Message-Id: <20070730125154.a7dab7ec.zaitcev@redhat.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create arch/x86_64/vdso/.gitignore and put vdso.lds into it.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

---

Utterly trivial but for some reason missing. V.odd. I must be
misunderstanding how this works, but just in case here's patch.

--- linux-2.6.23-rc1/arch/x86_64/vdso/.gitignore	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.23-rc1-nip/arch/x86_64/vdso/.gitignore	2007-07-30 12:37:46.000000000 -0700
@@ -0,0 +1 @@
+vdso.lds
