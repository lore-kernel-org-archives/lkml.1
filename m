Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbXGVUuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbXGVUuN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764976AbXGVUtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:49:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2103 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764950AbXGVUtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=BAnlkVY3JLOLNWc7difoRVEfAmyoLP30noIePU1GK2SuqV+9b/WK+bIFVQTtWA1soDt0dc1eLMCePgKbe/5am/QYWZCyC0PekoVKBxeyLtAjmRDk4C/SLaW4FUoBARLDt/HDi5vf57qrMke216+HHNEZm0P9hXf6nowxei4GWss=
Message-ID: <9e4733910707221349s462aa11bj714956f7cdc72aac@mail.gmail.com>
Date: Sun, 22 Jul 2007 16:49:48 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Git Mailing List" <git@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Git tree for old kernels from before the current tree
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing on with kernel archeology for embedded systems, any
interest in making a git tree with all of the kernel versions from the
beginning up to the start of the current git tree? No history in the
tree, just a simple way to quickly fetch and select a copy of all the
various old releases. I know they are all available ftp, git tree
would organize them all in one place and let you fetch them all at
once.

If this is small enough you could add it to the current kernel tree.
Git's super diffing performance might make this fairly small.

My dream system lets me checkout an ancient version, apply the diff
from the vendor (or expand a tarball), use git status to see what
files changed, and git diff to get detailed changes (all minus CVS
keyword expansion noise). Major bonus points if it can detect detect a
subsystem that has been backported.

-- 
Jon Smirl
jonsmirl@gmail.com
