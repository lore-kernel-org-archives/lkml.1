Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbXDVSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbXDVSGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbXDVSGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:06:20 -0400
Received: from fed1rmmtao101.cox.net ([68.230.241.45]:36899 "EHLO
	fed1rmmtao101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXDVSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:06:19 -0400
From: Junio C Hamano <junkio@cox.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Today's 'master' leaves .idx/.pack in 0400
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
	<7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
	<7vvefonvdz.fsf@assigned-by-dhcp.cox.net>
Date: Sun, 22 Apr 2007 11:06:18 -0700
In-Reply-To: <7vvefonvdz.fsf@assigned-by-dhcp.cox.net> (Junio C. Hamano's
	message of "Sun, 22 Apr 2007 10:58:48 -0700")
Message-ID: <7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With recent glibc, mkstemp() creates 0400 file.  Updated
pack-objects uses it in pack/idx writing without fixing this,
hence this problem.

Will have a fix hopefully shortly.

