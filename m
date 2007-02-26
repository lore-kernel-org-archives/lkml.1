Return-Path: <linux-kernel-owner+w=401wt.eu-S1030225AbXBZNbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030225AbXBZNbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXBZNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:31:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:50167 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030225AbXBZNbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nTAJmgFImIy7OL+GZvbGPTRB+V3pjz+o4/2Ukl56t+vGPDGznjedfKiSlJhjAAd9VwjeZ2Fm44y4TK67CPcJWHxlobckj7ga2q1E/wizIO2/XjkTLmmZ6QFrVk2Ldfj892Lr57Cwv9wQPm8gwq+61nw3ZM2Oz52saBFjFCd4KSo=
Message-ID: <9a8748490702260531h45a91113o611c272c0fe7b39f@mail.gmail.com>
Date: Mon, 26 Feb 2007 14:31:02 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: nfs@lists.sourceforge.net
Subject: nfs_update_inode: inode 309229856 mode changed, 0100644 to 0040755 - kernel 2.6.13.4
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a webserver running a rather old 2.6.13.4 kernel that a few
minutes ago surprised me by logging the following message :

 kernel: nfs_update_inode: inode 309229856 mode changed, 0100644 to 0040755

The server exporting the filesystem is running 2.6.18.1 (knfsd) -
nothing is logged on the server...

So a file changed type and permissions out of the blue.  A few
questions about that:

Any way I can identify the file (or is it a dir now ;) ?
Does anyone know if this is a known bug that's been fixed? I couldn't
find anything via google or git that looked like a fix.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
