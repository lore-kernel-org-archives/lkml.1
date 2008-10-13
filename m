Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYJMOEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYJMOEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYJMOEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:04:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40635 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753106AbYJMOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:04:10 -0400
Date: Mon, 13 Oct 2008 15:02:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: I have returned!
Message-ID: <20081013150231.294b38b6@lxorguk.ukuu.org.uk>
In-Reply-To: <48F34CB9.3020000@pobox.com>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48F2F138.6020103@kernel.org>
	<48F34CB9.3020000@pobox.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have returned!  muhahahahahaha....

Oh good..
--

ibmtr: PCMCIA IBMTR is ok on 64bit

From: Alan Cox <alan@redhat.com>

For whatever value of 'OK' can be applied to the use of token ring. Seems
the 32bit to 64bit cleanups missed re-enabling the pcmcia driver

Closes #7133 and also reviewed the code in question

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/pcmcia/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/pcmcia/Kconfig b/drivers/net/pcmcia/Kconfig
index e8f55d8..9b8f793 100644
--- a/drivers/net/pcmcia/Kconfig
+++ b/drivers/net/pcmcia/Kconfig
@@ -111,7 +111,7 @@ config ARCNET_COM20020_CS
 
 config PCMCIA_IBMTR
 	tristate "IBM PCMCIA tokenring adapter support"
-	depends on IBMTR!=y && TR && !64BIT
+	depends on IBMTR!=y && TR
 	help
 	  Say Y here if you intend to attach this type of Token Ring PCMCIA
 	  card to your computer. You then also need to say Y to "Token Ring
