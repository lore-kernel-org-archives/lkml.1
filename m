Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbXLEIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbXLEIX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 03:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXLEIXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 03:23:19 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:38655 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXLEIXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:23:18 -0500
Subject: IO-APIC discrepency between x86 subarches
From: Jon Masters <jonathan@jonmasters.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Dec 2007 03:22:42 -0500
Message-Id: <1196842962.25930.16.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

Can someone tell me what the current collective thinking is about
calling io_apic_sync during interrupt masking?

This has changed several times recently, and is different between x86
IA32 and x86_64. As Ingo noted a long while back, it should be fine, but
consistency is a nice thing. With that in mind, I'm thinking that the
shared io_apic files could do with a nice cleanup - one has inlines, the
other has DO_ACTION macros that are wrapped, etc.

Jon.


