Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYBYRAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYBYRAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYBYRAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:00:45 -0500
Received: from ik-out-1112.google.com ([66.249.90.178]:53447 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYBYRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:00:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jY+ikoYJVizN6JBEYIz67nc7aYPVE4Iio4bdX/ZdGP1/3EDz1IiSqq0rKMCi7WoUC9EKCQc2J3uNDgUGV7LvAraN5pS8BaN5sT0NERyuYB7jVq/sRq9cTYVvQrUMVL50H/aRcI4z+QGBX0jkI7ibDY6XK114DUxru1VkcGfjGqE=
Message-ID: <7c86c4470802250900g1eea7a26m1900c4d8ed621dfd@mail.gmail.com>
Date: Mon, 25 Feb 2008 18:00:32 +0100
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 new perfmon kernel code base + libpfm + pfmon finally available!
Cc: ia64 <linux-ia64@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have finally released the perfmon2 kernel patch for kernel v2.6.24. It
took longer than expected to due my job change and several technical issues
related to perfmon kernel bugs.

The perfmon version been changed to v2.8 due to some minor changes in the
interface. The major changes are:
 - support for IBM Power4 and Power 6 (Kevin Corey)
 - support for Sun Sparc Ultra12, Ultra3, 3i, 3+, 4+, Niagara,
Niagara2 (David S. Miller)
 - support for Intel Penryn-class processors (model 23)
 - support for MIPS R12000 (Vince Weaver)
 - support for Pentium Pro (Vince Weaver)
 - IBM Cell and Sony PS3 updates (Takashi Yamamoto)
 - allow user-level RDPMC for self-monitoring sessions
 - merged x86 code
 - perfmon statistics now using debugfs
 - set switch timeout now using hrtimer infrastructure
 - spin lock macros to hide IBM lazy interrupt masking
 - pfm_create_evtsets() fails if timeout is not multiple of clock resolution
 - PFM_MSG_END no longer sent to non self-monitoring sessions

There is also a new release for libpfm, now at version 3.3. The
changes include:
 - full event table for AMD Phenom (a.k.a. Barcelona) (Robert Richter)
 - support for Sun Sparc Ultra12, Ultra3, 3i, 3+, 4+, Niagara,
Niagara2 (David S. Miller)
 - support for Pentium II, Pentium Pro (Vince Weaver)
 - support for Intel Penryn-class processor
 - support for Pentium 4 event replay tag (Dan Terpstra)
 - initial support for Sicortex ICAE9A/ICE9B processors (Phil Mucci)
 - Cray X2 updates (Steve Kaufmann)
 - allow numerical values for unit masks (Dan Terpstra)

Finally, a new major version of pfmon, now at pfmon-3.3. Among the many changes:
 - support for Sun Sparc  Ultra12, Ultra3, Ultra3i, Ultra3Plus,
Ultra4Plus, Niagara1, Niagara2 (David S. Miller)
 - support Intel Pentium II, Intel Pentium Pro support (Vince Weaver)
 - IBM Cell updates (Takashi Yamamoto)
 - complete rewrite of the symbol table parsing and management (Andrzej Nowak)
 - can now correlate symbols in shared libraries
 - can now correlate symbols across dlopen()/dlclose() (Andrzej Nowak)
 - can now correlate samples to programs in system-wide mode (Phil Mucci)
 - MIPS updates (Phil Mucci)

Thanks to all the contributors and in particular to David S. Miller
for his exceptional work on adding support for Sun processors so quickly. I
also would like to thank Andrzej Nowak (CERN) for his work on improving pfmon.
This was a lot of hard work done in a short period of time.

As usual all files and more detailed change logs can be downloaded
from our website at:

       http://perfmon.sourceforge.net

Enjoy,
