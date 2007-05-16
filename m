Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbXEPXho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbXEPXho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760654AbXEPXhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:37:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760312AbXEPXhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:37:20 -0400
Message-ID: <464B9573.8030407@zytor.com>
Date: Wed, 16 May 2007 16:36:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie>
In-Reply-To: <20070516174046.GE10225@skynet.ie>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050000090902000504010904"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050000090902000504010904
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Correction, does *this patch* do it for you?

	-hpa


--------------050000090902000504010904
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/setup.ld b/arch/i386/boot/setup.ld
index e9ca0c2..c9c5530 100644
--- a/arch/i386/boot/setup.ld
+++ b/arch/i386/boot/setup.ld
@@ -44,5 +44,5 @@ SECTIONS
 
 	/DISCARD/ : { *(.note*) }
 
-	ASSERT(_end <= 0x8000, "Setup too big!")
+	. = ASSERT(_end <= 0x8000, "Setup too big!");
 }

--------------050000090902000504010904--
