Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYBKNRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYBKNRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYBKNRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:17:42 -0500
Received: from trashmail.net ([213.155.82.90]:47892 "EHLO trashmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYBKNRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:17:41 -0500
To: linux-kernel@vger.kernel.org
From: rzryyvzy <rzryyvzy@trashmail.net>
Subject: Help debugging filesystem activity?
Message-Id: <20080211131713.DC7435193B631@trashmail.net>
Date: Mon, 11 Feb 2008 14:17:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My hard disk on my server is all the time readding and writing some files (I can see it with dstat). However I would like to know which files exactly are readden or written all the time. I know that each filesystem activity goes by the VFS (virtual filesystem).
Is it possible to see all current open files in the VFS?
For example with a command like:
$ cat /proc/fs/vfs/open_files
$ cat /proc/fs/vfs/reading_files
$ cat /proc/fs/vfs/writing_files

?
Is there a possibility? It should be on the VFS level to be independent of the used filesystem.

-- 
Best regards

-- 
E-Mail sent with anti-spam site TrashMail.net!
Free disposable email addresses: http://www.trashmail.net/
