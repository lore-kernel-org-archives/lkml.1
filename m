Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbXFTU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbXFTU7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXFTU7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:59:30 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:42864 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXFTU73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:59:29 -0400
X-IronPort-AV: i="4.16,444,1175497200"; 
   d="scan'208"; a="5281087:sNHT18890286"
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Subject: scripts/checkpatch.pl refers to non-existent Documentation/Documentation/volatile-considered-harmful.txt
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 20 Jun 2007 13:59:15 -0700
Message-ID: <ada3b0m8hr0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jun 2007 20:59:15.0497 (UTC) FILETIME=[DC7F6990:01C7B37D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4a0df2ef added the following to scripts/checkpatch.pl:

    print "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n";

but Linus's tree has no such file.  not sure what the right thing to
do here is, since I assume we do ultimately want something of the sort
in Documentation...

 - R.
