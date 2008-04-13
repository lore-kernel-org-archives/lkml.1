Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYDMKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYDMKAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYDMKAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:00:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4912 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752478AbYDMKA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:00:29 -0400
Date: Sun, 13 Apr 2008 12:00:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413100022.GB4639@ucw.cz>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com> <20080412170304.54f139e2.akpm@linux-foundation.org> <20080413033344.GA27494@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413033344.GA27494@hash.localnet>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Uncached lookups in particular are very slow because directories are 
> essentially a huge hash table.  You might have to seek through several 
> siblings in a bucket to get to the target file.
> 
> They seem to have designed for online recovery with checksumming and
> mirroring of every FS object.  This module updates these, but it does
> not do any online checking/repair.  I have written an mkfs/fsck, though.

This is actually quite interesting. Checksuming filesystem sounds
pretty useful.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
