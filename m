Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYKIMyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYKIMyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYKIMyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:54:08 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:34209 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbYKIMyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:54:07 -0500
X-Sasl-enc: FmEGBF26Tcl4hmtAZuAjrKJB+Gqx9roE0W7Qmt5JG/sD 1226235245
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] thinkpad-acpi regression fix for 2.6.28-rc
Date: Sun,  9 Nov 2008 10:54:01 -0200
Message-Id: <1226235242-11130-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081109113011.GB8329@khazad-dum.debian.net>
References: <20081109113011.GB8329@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch should fix a reported regression on fan_resume (not
on bugzilla, report on the LKML and ibm-acpi-devel).

Tino, Rafael, please test and reply with a tested-by line.  I have
tested it here, but my T43 has a fan quirk that might get in the
way...

Len, if we get reports that this fixes the regression, it would be
really nice if you could send it to Linus for 2.6.28-rc.  It is a
rather annoying regression.  Otherwise, a revert of the commit who
broke things (listed in the patch commit log) is also acceptable.

Thank you.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
