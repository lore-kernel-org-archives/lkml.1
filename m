Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYJ0Wyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYJ0Wyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYJ0Wya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:54:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbYJ0Wy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:54:29 -0400
Date: Mon, 27 Oct 2008 15:52:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com, pavel@suse.cz, ukleinek@strlen.de
Subject: Re: [PATCH 1/8] Add scripts/get_maintainer.pl
Message-Id: <20081027155254.a710c779.akpm@linux-foundation.org>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
	<ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 16:09:19 -0700
Joe Perches <joe@perches.com> wrote:

> A script to parse file pattern information in MAINTAINERS
> and return selected information about a file or patch
> 
> $ scripts/get_maintainer.pl
> usage: ./scripts/get_maintainer.pl [options] patchfile
>        ./scripts/get_maintainer.pl [options] -f file
> version: 0.12

Example output would be nice to see.  Hopefully it is in the

	Joe Perches <joe@perches.com>

form, ready to be pasted into an email client?

otoh, we'll sometimes also want the

	joe@perches.com,akpm@linux-foundation.org

form for use by scripts.


Also, this:

 MAINTAINERS | 1096 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 1094 insertions(+), 2 deletions(-)

isn't practical for me or Stephen to carry, I'm afraid.  That's
probably the most-patched file in the kernel.  This will need to be a
direct you->Linus thing.

I think the feature is sorely needed and will prove useful.
