Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXEXKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXEXKVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 06:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbXEXKVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 06:21:24 -0400
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:38066 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXEXKVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 06:21:23 -0400
Date: Thu, 24 May 2007 12:21:22 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 and libata/shutdown
Message-ID: <20070524102122.GA8652@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After trying 2.6.22-rc2, I noticed the warning message from libata about
upgrading shutdown(8). First, I have two SATA disks, and get the warning for
only one of them. Second, I double-checked the source of shutdown for my
distro (Debian unstable), and do not see anything related to issueing
STANDBYNOW.

So, is the warning bogus, or could something else trigger the problem on
one disk only (if getting only one message means that the problem is
only detected on one disk).


As these messages come very late in the shutdown process, I do not have
an easy way to reproduce them.


Thanks in advance,

-- 
Damien Wyart
