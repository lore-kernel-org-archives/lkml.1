Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXKXACM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXKXACM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 19:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXKXAB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 19:01:59 -0500
Received: from japan.chezphil.org ([77.240.5.4]:4735 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXKXAB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 19:01:59 -0500
X-Greylist: delayed 2459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Nov 2007 19:01:58 EST
To: <linux-kernel@vger.kernel.org>
Date: Fri, 23 Nov 2007 23:20:55 +0000
Subject: No error when inotify_add_watch(/an/NFS/file)
Message-ID: <1195860055386@dmwebmail.japan.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Experts,

NFS doesn't work with inotify (and it looks like it can't, certainly 
not before NFS v4.1).  However, if I give an NFS filename to 
inotify_add_watch(), I don't get an error.

If it indicated an error in this case then I could easily fall back to 
some sort of polling.  Without an error, I need some other way to 
detect NFS (and any other non-inotify-compatible filesystems).

Any thoughts?


Phil.

(If you Cc: me in any replies I'll see them sooner.)



