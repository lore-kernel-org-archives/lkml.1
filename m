Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYL0Pb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYL0Pb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 10:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYL0PbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 10:31:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbYL0PbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 10:31:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/2] PCI PM fixes for 2.6.29
Date: Sat, 27 Dec 2008 16:27:32 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812271627.32781.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, the previous attempt was HTML-formatted.]

Hi Jesse,

The following two patches contain fixes of PCI suspend-resume routines.

The first one corrects the suspend-resume handling for PCI Express ports after
commit 2bdc985ac3fcdb4ae9672feeb14de2c525967899 (in your tree).

The second one is a fix for devices without PM capability.

Sorry for being late with them, but I had to make sure that the first patch
doesn't break the test box affected by bug #12121 again.

Thanks,
Rafael

