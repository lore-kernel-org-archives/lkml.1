Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYCKHDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYCKHDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 03:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbYCKHDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 03:03:08 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:55583 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYCKHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 03:03:07 -0400
Subject: pm_idle generic register/unregister
From: Jon Masters <jonathan@jonmasters.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 11 Mar 2008 03:02:34 -0400
Message-Id: <1205218954.27299.91.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

I'm working on a patch (needed for the Real Time tree) to cleanup use of
the pm_idle pointer, something each architecture defines and optionally
calls from within the CPU idle loop, if it's defined. The problem is
that there's a classical bug (which has existed for quite some time)
whenever a function providing that pointer is unloaded from under it.

So, I'm proposing an ordered list of pm_idle functions with a
register/unregister function to ensure safe access. Anyway, before I
post that, does anyone have a good reason for why things are as they are
currently in the kernel with respect to the pm_idle stuff? Cruftiness?

Jon.


