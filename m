Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYESI54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYESI54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYESI5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:57:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57273 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYESI5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:57:44 -0400
Date: Mon, 19 May 2008 10:58:42 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/4] ext3: enable barriers by default
Message-ID: <20080519085842.GA2013@elf.ucw.cz>
References: <482DDA56.6000301@redhat.com> <482DDB13.1050708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DDB13.1050708@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-05-16 14:05:55, Eric Sandeen wrote:
> I can't think of any valid reason for ext3 to not use barriers when
> they are available;  I believe this is necessary for filesystem
> integrity in the face of a volatile write cache on storage.
> 
> An administrator who trusts that the cache is sufficiently battery-
> backed (and power supplies are sufficiently redundant, etc...)
> can always turn it back off again.
> 
> SuSE has carried such a patch for quite some time now.
> 
> Also document the mount option while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Acked-by: Jan Kara <jack@suse.cz>

Yes please. Safe defaults are the way to go.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
