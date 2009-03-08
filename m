Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZCHSRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZCHSRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZCHSRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:17:24 -0400
Received: from col0-omc1-s8.col0.hotmail.com ([65.55.34.18]:15513 "EHLO
	col0-omc1-s8.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbZCHSRX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:17:23 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Mar 2009 14:17:23 EDT
Message-ID: <COL116-W44867929BE0D134DE768B6DAA30@phx.gbl>
X-Originating-IP: [84.216.37.216]
From: Peter Hallberg <hallberg68@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Re: doubt about path_walk() function
Date: Sun, 8 Mar 2009 19:11:11 +0100
Importance: Normal
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Mar 2009 18:11:11.0817 (UTC) FILETIME=[43293390:01C9A019]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> linuxshield/scan.c|998| error: implicit declaration of function ‘path_walk’
> Searching in the internet, I can see that this function was removed in
> one some kernel version, so how can I fix this problem ?

It has been replaced with vfs_path_lookup, the fix for another fs looks like this:
-    ret = path_walk(cachename, &nd);
+    ret = vfs_path_lookup(nnpfsp->cachedir, nnpfsp->cacheroot,
+			  cachename,
+			  flags & O_CREAT ? LOOKUP_PARENT : 0,
+			  &nd);


_________________________________________________________________
Dela foton på ett smidigt sätt med Windows Live™ Photos.
http://www.microsoft.com/windows/windowslive/products/photos.aspx