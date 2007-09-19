Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbXISXwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbXISXwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXISXvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:51:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46850 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbXISXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:51:51 -0400
Date: Wed, 19 Sep 2007 16:50:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 2/5][GFS2] Cleanup explicit check for mandatory locks
Message-Id: <20070919165054.cd862876.akpm@linux-foundation.org>
In-Reply-To: <46EE3228.30002@openvz.org>
References: <46EE3228.30002@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 11:52:08 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> Subject: [PATCH 2/5][GFS2] Cleanup explicit check for mandatory locks
> Subject: [PATCH 3/5][9PFS] Cleanup explicit check for mandatory locks
> Subject: [PATCH 4/5][AFS] Cleanup explicit check for mandatory locks
> Subject: [PATCH 5/5][NFS] Cleanup explicit check for mandatory locks

Boring administrivial note: all these patches effectively had the same
title.  Because the text in "[]" is considered to be something which should
be discarded when the patch is applied.

This convention is useful because things like sequence numbering, kernel
version information, etc are only relevant when you sent the patch and are
not relevant when the patches hit the git tree.

Bottom line: please do include the subsystem ideitification as you have
tried to do, but please do not place it inside "[]".

As described in the very fine
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt, better
Subject:s here would have been

Subject: [PATCH 2/5] GFS2: Cleanup explicit check for mandatory locks
Subject: [PATCH 3/5] 9PFS: Cleanup explicit check for mandatory locks
Subject: [PATCH 4/5] AFS: Cleanup explicit check for mandatory locks
Subject: [PATCH 5/5] NFS: Cleanup explicit check for mandatory locks

Extreme trivia: I don't consider a colon to terminate a sentence, so if I
can be bothered I'll convert "Cleanup" there to "cleanup".  And I don't
consider "cleanup" to be a word, so it becomes "clean up".  And I'll
usually remvoe the final "." from the end of the subject because it's
basically just a waste of space.

