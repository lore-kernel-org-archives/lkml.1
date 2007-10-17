Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbXJQCXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbXJQCXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935882AbXJQCWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:22:47 -0400
Received: from fencepost.gnu.org ([140.186.70.10]:48568 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935795AbXJQCWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:22:45 -0400
Subject: Distinguishing releases from pre-rc snapshots
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Oct 2007 22:22:43 -0400
Message-Id: <1192587763.3672.24.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm trying to keep some external drivers up to date with the kernel, and
the first two weeks after the release is the worst time for me.  There
is no way to distinguish the current git kernel from the latest release.
It's only after rc1 is released that I can use preprocessor to check
LINUX_VERSION_CODE.

Before that, I have to rely on tricks or change the kernel version
myself in a separate patch and tell other team members to do the same.

Basically, I only care about kernel releases, but I also want to
increase the probability that the next standalone release of my drivers
will work with the next release on the kernel.  That's why I check
compatibility with the tip of the linux-2.6 repository.

Calling git version of Linux "2.6.23" one day before 2.6.24-rc1 is
preposterous, as it's likely to be compatible with 2.6.24, not 2.6.23.
Calling git version of Linux "2.6.24-pre" or something next day after
2.6.23 release is OK in comparison, since nobody developing external
drivers cares about old revisions of the kernel.  And the developers of
the kernel itself shouldn't care about versions at all.

It would be nice to establish a rule to increment the version number
immediately after the kernel release and have a suffix to indicate that
it's a pre-rc version.  "rc0" is my personal favorite.

It would also be helpful for other repositories, as it would indicate
whether any post-release changes have been merged in.

-- 
Regards,
Pavel Roskin

