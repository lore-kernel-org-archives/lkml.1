Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059Ab0AMQkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0AMQkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688Ab0AMQkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:40:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1100 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab0AMQkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:40:37 -0500
Subject: [PATCH] Makefile: Document ability to make file.lst and file.S
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>, Michal Marek <mmarek@suse.cz>
Cc: William Allen Simpson <william.allen.simpson@gmail.com>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kbuild@vger.kernel.org
In-Reply-To: <20100113155323.GB24818@basil.fritz.box>
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com>
	 <20100113115617.GA24818@basil.fritz.box> <4B4DE887.6030602@gmail.com>
	 <20100113155323.GB24818@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 08:40:35 -0800
Message-ID: <1263400835.8011.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 16:53 +0100, Andi Kleen wrote:
> On Wed, Jan 13, 2010 at 10:36:39AM -0500, William Allen Simpson wrote:
> > What make command would you suggest to get the interleaved asm?
> make path/to/file.lst
> (or .S -- you might need uptodate binutils if the lst listing is messed up)

I didn't know that was possible.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/Makefile b/Makefile
index 9f64552..4557d58 100644
--- a/Makefile
+++ b/Makefile
@@ -1248,7 +1248,9 @@ help:
 	@echo  '  firmware_install- Install all firmware to INSTALL_FW_PATH'
 	@echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
 	@echo  '  dir/            - Build all files in dir and below'
-	@echo  '  dir/file.[ois]  - Build specified target only'
+	@echo  '  dir/file.[oisS] - Build specified target only'
+	@echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
+	@echo  '                    (needs a previous build and System.map)'
 	@echo  '  dir/file.ko     - Build module including final link'
 	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'



