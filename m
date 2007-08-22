Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXHVBgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXHVBgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbXHVBgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:36:21 -0400
Received: from gherkin.frus.com ([192.158.254.49]:34918 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXHVBgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:36:20 -0400
Subject: [BUG?] 2.6.23-rc3 on alpha
To: linux-kernel@vger.kernel.org
Date: Tue, 21 Aug 2007 20:36:18 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070822013618.BE293DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Richard for the "aboot" fixes.

I'm seeing something new and strange with 2.6.23-rc3 that I wasn't
seeing in the 2.6.22+ kernels.  I've got the bootlogo code enabled,
and at the point during system initialization where the logo
disappears, the console switches from tty1 to tty2.  I can switch
back to tty1, so other than the unexpected console tty switch, there
doesn't seem to be anything "unfortunate" happening.

Any ideas/explanations?  It's completely repeatable.  I don't think
it's related to the "aboot" patches :-).

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
