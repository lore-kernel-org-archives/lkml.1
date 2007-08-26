Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXHZSvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXHZSvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 14:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXHZSuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 14:50:52 -0400
Received: from zer09.zwecker.de ([88.198.57.35]:55006 "EHLO zer09.zwecker.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXHZSuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 14:50:51 -0400
X-Greylist: delayed 1154 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 14:50:50 EDT
Subject: PROBLEM: Suspend corrupts bios clock since 2.6.21
From: Andreas Steffan <a.steffan@deas-online.de>
To: linux-pm@lists.linux-foundation.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 26 Aug 2007 20:31:00 +0200
Message-Id: <1188153060.14603.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo everybody,

I am running fedora core 7 on my Dell latitude D810 notebook (BIOS
rev A05).

Since 2.6.21 I found that suspending (to disk and to ram) corrupts
the bios clock most of the time (not always). The corruption is
happening during suspend. When I enter the system bios right after
I switch the system back on, I find the bios clock is set to a time
far in the future (many years). I guess that problem is related to
the clock changes that where introduced with 2.6.21.

Please let me know if you want me to provide further information to
get this problem fixed.

If there is a known quirk to work around this problem, I would
really appreciate a hint.

PS: I have not yet tried 2.6.22.4-65.fc7, but the latest 2.6.22 kernel
before showed the same behaviour for me.
--
regards 
Andreas

+-----------------------------------------------------------+
Andreas Steffan              email: a.steffan@deas-online.de
Hamburg, Germany             mobil: +49179 3903615
+-----------------------------------------------------------+

In theory, practice and theory are the same, but in practice
they are different -- Larry McVoy

