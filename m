Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYFAORw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYFAORw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYFAOQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:16:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4376 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbYFAOQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:16:52 -0400
Date: Sat, 31 May 2008 09:15:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tom Spink <tspink@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] xfs: Make XFS use the new file system init infrastructure
Message-ID: <20080531071536.GA5405@ucw.cz>
References: <1211737699-25615-1-git-send-email-tspink@gmail.com> <1211737699-25615-2-git-send-email-tspink@gmail.com> <1211737699-25615-3-git-send-email-tspink@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211737699-25615-3-git-send-email-tspink@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-25 18:48:19, Tom Spink wrote:
> This patch makes XFS use the file system type specific init and exit
> callbacks, so that XFS only initialises when it's used for the first
> time.
> 
> This is useful for when XFS is compiled into the kernel, but never
> actually used as it stops XFS from creating global threads, until
> they are needed.

Yes please. Removing gazillion kernel threads when xfs is unused is
nice.

You should probably have cced fsdevel and xfs lists?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
