Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZEYIoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZEYIoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbZEYInx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:43:53 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:46506 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbZEYInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:43:52 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 15/32] union-mount: Documentation 
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Blunck <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
In-Reply-To: <200905250903.08165.arnd@arndb.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-16-git-send-email-jblunck@suse.de> <8417.1243232743@jrobl> <200905250903.08165.arnd@arndb.de>
Date: Mon, 25 May 2009 17:43:10 +0900
Message-ID: <7294.1243240990@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:
> Right, but that is consistent with how the kernel would treat a
> rename from one mount point to another, and tools like 'mv'
> can handle this in user space.

Yes, that is the description in the union mount document.
While it says to rename a regular file is implemented, the code differs
actually.
----------------------------------------
+Rename across different levels of the union is implemented as a copy-up
+operation for regular files. Rename of directories simply returns EXDEV, the
+same as if we tried to rename across different mounts. Most applications have
	:::
----------------------------------------
