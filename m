Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbYAVPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbYAVPN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 10:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYAVPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 10:13:50 -0500
Received: from subdivi.de ([77.37.6.11]:2263 "EHLO subdivi.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYAVPNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 10:13:49 -0500
X-Greylist: delayed 1899 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 10:13:49 EST
Date: Tue, 22 Jan 2008 15:41:58 +0100
From: Helmut Grohne <helmut@subdivi.de>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: SECCOMP documentation outdated in some arch/*/Kconfig
Message-ID: <20080122144156.GA29993@alf.mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I didn't find out whom to report this bug to and thus report to
linux-kernel@vger.kernel.org as described in
http://kernel.org/pub/linux/docs/lkml/reporting-bugs.html.

I'm posting from outside, so please CC me.

[1] The description about seccomp is outdated in some arch/*/Kconfig
    files.

[2] According to the source (2.6.23.14) seccomp is to be activated using
    pcrtl. It was previously activated using a file /proc/<pid>/seccomp.
    The Kconfig documentation (also displayed in menuconfig) does not
    reflect this change and is thus wrong.

[3] seccomp documentation Kconfig

[4] 2.6.23.14, seems to also apply to git head:
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=arch/x86/Kconfig;h=80b7ba4056dbbb566841c1e1cbef9475730fe199;hb=HEAD

[5] no oops

[6] less arch/x86_64/Kconfig
    /SECCOMP

[7] Ask me again if you really think you need information about the
    environment for a documentation bug.

Helmut
