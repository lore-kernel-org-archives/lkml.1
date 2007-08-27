Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbXH0Vp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbXH0Vp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbXH0VbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:31:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765565AbXH0VbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:31:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 0/4] Hibernation: Arbitrary boot kernel support on x86_64 (rev. 2)
Date: Mon, 27 Aug 2007 23:31:27 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272331.28584.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first two patches in this series make it possible to restore the memory
state from a hibernation image with the help of a kernel different from the
image one.

The first patch adds the generic, platform independent code needed for that.
The second patch implements the idea on x86_64.

The remaining two patches remove some implicit assumptions about the boot and
image kernels from the x86_64 restore code.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

