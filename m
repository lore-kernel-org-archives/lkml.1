Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbXEHIep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbXEHIep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934592AbXEHIep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:34:45 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47801 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469AbXEHIeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:34:44 -0400
Date: Tue, 8 May 2007 10:33:22 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Borislav Petkov <bbpetkov@yahoo.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/macintosh: remove default y from Kconfig (was:
 Re: 2.6.21-mm1)
In-Reply-To: <20070507103519.GA4725@gollum.tnic>
Message-ID: <Pine.LNX.4.61.0705081028440.17280@yvahk01.tjqt.qr>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <20070507103519.GA4725@gollum.tnic>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 7 2007 12:35, Borislav Petkov wrote:
>
>I don't think I need macintosh drivers for my x86 arch selected in by default,
>  do I?

For new config variables that were introduced, I set them to 'default y'
so when upgrading from an older .config, it does not deselect the drivers
_inside_ the new menuconfig. People who have CONFIG_MAC_EMUMOUSEBTN=y
will magically get it set to =n because MACINTOSH_DRIVERS is not y.

Whether you need macintosh on i386... oh well, ask someone who knows.
Fact is, that at least SUSE has CONFIG_MAC_EMUMOUSEBTN=y but I
wonder wtf for.



>Index: trees/linux-mm/drivers/macintosh/Kconfig
>===================================================================
>--- linux-mm.orig/drivers/macintosh/Kconfig
>+++ linux-mm/drivers/macintosh/Kconfig
>@@ -2,7 +2,6 @@
> menuconfig MACINTOSH_DRIVERS
> 	bool "Macintosh device drivers"
> 	depends on PPC || MAC || X86
>-	default y

How about
	default y if PPC || MAC
then?

Jan
-- 
