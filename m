Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXICRN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXICRN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXICRNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:13:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17946 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXICRNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:13:48 -0400
Date: Mon, 3 Sep 2007 10:12:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send quota messages via netlink
Message-Id: <20070903101234.c74ead59.randy.dunlap@oracle.com>
In-Reply-To: <20070903144336.GH7524@duck.suse.cz>
References: <20070828141318.GC5869@duck.suse.cz>
	<20070828215128.d8147a43.akpm@linux-foundation.org>
	<20070903144336.GH7524@duck.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 16:43:36 +0200 Jan Kara wrote:

> User-Agent: Mutt/1.5.13 (2006-08-11)

Mutt knows how to send patches inline vs. attachments... :(


Anyway, on to the patch.  Thanks for adding the new doc file.


+This command is used to send a notification about any of the above mentioned
+events. Each message has six attributes. These are (type of the argument is
+in braces):

s/braces/parentheses/

+        QUOTA_NL_A_QTYPE (u32)
+	  - type of quota beging exceeded (one of USRQUOTA, GRPQUOTA)

s/beging/being/


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
