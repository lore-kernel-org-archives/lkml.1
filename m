Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYHAWwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYHAWwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYHAWv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:51:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYHAWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:51:56 -0400
Subject: Re: Error on Make Modules [2.6.27-rc1]
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Yudha Harimantoro T <yudha.ht@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Avuton Olrich <avuton@gmail.com>
In-Reply-To: <20080801224153.GL19682@cs181140183.pp.htv.fi>
References: <264b990a0807312306jc064bbbp144342de555ac4f1@mail.gmail.com>
	 <20080801224153.GL19682@cs181140183.pp.htv.fi>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 23:51:40 +0100
Message-Id: <1217631100.3719.44.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 01:41 +0300, Adrian Bunk wrote:
> Can you somehow hide this message?

I'll leave the __fw_install one alone, so that if there's nothing to do
for 'make firmware_install' it says so rather than just doing nothing.
The other two can shut up, as requested.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index f63a663..6bf8e87 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -50,8 +50,12 @@ PHONY +=  __fw_install __fw_modinst FORCE
 .PHONY: $(PHONY)
 
 __fw_install: $(installed-fw)
+
 __fw_modinst: $(installed-mod-fw)
+	@:
+
 __fw_modbuild: $(addprefix $(obj)/,$(mod-fw))
+	@:
 
 FORCE:
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

