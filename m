Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbZEYG0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbZEYG0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZEYG0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:26:23 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:51808 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZEYG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:26:23 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 15/32] union-mount: Documentation 
To: Jan Blunck <jblunck@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
In-Reply-To: <1242662968-11684-16-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <1242662968-11684-16-git-send-email-jblunck@suse.de>
Date: Mon, 25 May 2009 15:25:43 +0900
Message-ID: <8417.1243232743@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Blunck:
> +Rename across different levels of the union is implemented as a copy-up
> +operation for regular files. Rename of directories simply returns EXDEV, the
> +same as if we tried to rename across different mounts. Most applications have
> +to handle this case anyway. Some applications do not expect EXDEV on
> +rename operations within the same directory, but these applications will also
> +be broken with bind mounts.

Is renaming a regular file supported?
Accrding to the change in "[PATCH 24/32] union-mount: in-kernel file
copy between union mounted filesystems", every rename under union seems
to be rejected.

link(2) may be similar.
When a "fileA" exists in the lower fs only, link("fileA", "new_file")
will return EXDEV too.


J. R. Okajima
