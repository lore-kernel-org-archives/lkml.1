Return-Path: <linux-kernel-owner+w=401wt.eu-S934217AbZAPQqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934217AbZAPQqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbZAPQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:46:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39232 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZAPQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:45:58 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org
Cc: aarcange@redhat.com, Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Fri, 16 Jan 2009 17:45:39 +0100
Message-Id: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi folks,

Next round of the preadv & pwritev patch series.  Had no review comments
to fix.  That means it is ready to be merged, right?

Changes:
 - compat_sys_{read,write}v bugfix patch dropped (merged).
 - rebase to latest git, adapt to CVE-2009-0029 changes.

How to proceed now?  Is there a syscall maintainer where I could queue
up the patches?  If not, anyone (akpm?) willng to pick this up?  Should
I try to send to Linus directly?

What is the usual way to handle the arch-specific syscall windup?  I'd
prefer to leave that to the arch maintainers as they know best what
needs to be done, is that ok?  Right now only x86 (/me) and mips (patch
from Ralf Baechle) is covered ...

cheers,
  Gerd

