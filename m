Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbZDEXlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbZDEXlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZDEXlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:41:37 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:35602 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbZDEXlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:41:36 -0400
Message-ID: <49D941C1.1050007@lougher.demon.co.uk>
Date: Mon, 06 Apr 2009 00:41:53 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: squashfs-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Linux Embedded Maillist <linux-embedded@vger.kernel.org>
Subject: Squashfs 4.0 tools (for 2.6.29) released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm pleased to announce the first release of the squashfs 4.0 tools.
These are needed by any Squashfs users using linux 2.6.29.  They are available
from http://sourceforge.net/projects/squashfs

The changes from the change-log are:

1. Unsquashfs improvements:

1.1 Support for 4.0 filesystems added.
1.2 Swapping macros rewritten.
1.3 Unsquashfs code restructured and split into separate files.

2. Mksquashfs improvements:

2.1 Swapping macros rewritten.  Fixed little-endian layout allows
     code to be optimised and only added at compile time for
     big endian systems.
2.2 Support for pseudo files added.

New Mksquashfs options

Mksquashfs now supports pseudo files, these allow fake directories, character
and block devices to be specified and added to the Squashfs filesystem being
built, rather than requiring them to be present in the source directories.
This, for example, allows device nodes to be added to the filesystem without
requiring root access.

Phillip
