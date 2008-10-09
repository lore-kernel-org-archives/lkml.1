Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYJISHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYJISHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYJISG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:06:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16949 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYJISG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:06:58 -0400
Date: Thu, 9 Oct 2008 11:06:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Warne <nick@ukfsn.org>, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] doc/cdrom: Trvial documentation error, file not present
Message-Id: <20081009110630.32c0d2f7.randy.dunlap@oracle.com>
In-Reply-To: <20081005014624.0c8aa924@sauron.linicks.net>
References: <20081005014624.0c8aa924@sauron.linicks.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 01:46:24 +0100 Nick Warne wrote:

> In Documentation/cdrom/ide-cd, from line 148 is:
> 
> "Lacking anything else, you could use the
> cdtester program in Documentation/cdrom/sbpcd".
> 
> This file is not present in stable 2.6.26.5 at least.


From: Randy Dunlap <randy.dunlap@oracle.com>

The sbpcd tester program is not included in the kernel source tree,
so remove the reference to it.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Nick Warne <nick@ukfsn.org>
---
 Documentation/cdrom/ide-cd |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.27-rc9-git2.orig/Documentation/cdrom/ide-cd
+++ linux-2.6.27-rc9-git2/Documentation/cdrom/ide-cd
@@ -145,8 +145,7 @@ useful for reading photocds.
 
 To play an audio CD, you should first unmount and remove any data
 CDROM.  Any of the CDROM player programs should then work (workman,
-workbone, cdplayer, etc.).  Lacking anything else, you could use the
-cdtester program in Documentation/cdrom/sbpcd.
+workbone, cdplayer, etc.).
 
 On a few drives, you can read digital audio directly using a program
 such as cdda2wav.  The only types of drive which I've heard support
