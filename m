Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbYGUDEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbYGUDEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbYGUDD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:03:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYGUDDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:03:55 -0400
Message-Id: <20080721022823.896799736@suse.de>
User-Agent: quilt/0.46_cvs20080326-18
Date: Mon, 21 Jul 2008 04:28:23 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [genksyms patch 0/4] Checksum tracking and tweaking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam and all,

we are having two kinds of problems with genksyms today: fake checksum changes
without actual ABI changes, and changes which we would rather like to ignore
(such as an additional field at the end of a structure that modules are not
supposed to touch, for example).

I have thought about ways to improve genksyms and compute checksums differently
to avoid those problems, but in the end I don't see a fundamentally better way.
So here are some genksyms patches for at least making the checksums more easily
manageable, if we cannot fully fix them.

In addition to the bugfixes (the first two patches), this allows genksyms to track
checksum changes and report why a checksum changed (third patch), and to
selectively ignore changes (fourth patch).

Any thoughts?

Thanks,
Andreas

