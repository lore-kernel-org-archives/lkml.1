Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXBNSJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXBNSJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXBNSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:09:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbXBNSJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:09:43 -0500
Date: Wed, 14 Feb 2007 13:09:15 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: dbrownell@users.sourceforge.net
Subject: loosen dependancy on rtc cmos
Message-ID: <20070214180915.GA6412@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dbrownell@users.sourceforge.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This option is useful for all of the X86 subarchs afaik (and especially X86_GENERICARCH).

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.20.noarch/drivers/rtc/Kconfig~	2007-02-14 13:07:07.000000000 -0500
+++ linux-2.6.20.noarch/drivers/rtc/Kconfig	2007-02-14 13:07:13.000000000 -0500
@@ -101,7 +101,7 @@ comment "RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS' real time clock"
-	depends on RTC_CLASS && (X86_PC || ALPHA || ARM26 || ARM \
+	depends on RTC_CLASS && (X86 || ALPHA || ARM26 || ARM \
 		|| M32R || ATARI || POWERPC)
 	help
 	  Say "yes" here to get direct support for the real time clock

-- 
http://www.codemonkey.org.uk
