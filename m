Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbZDHNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbZDHNL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932869AbZDHNIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:08:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37749 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbZDHNIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:08:34 -0400
Date: Wed, 8 Apr 2009 15:08:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 01/13] buffer: switch do_emergency_thaw() away from
	pdflush_operation()
Message-ID: <20090408130832.GA5178@kernel.dk>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com> <1239192016-19857-2-git-send-email-jens.axboe@oracle.com> <20090408130346.GA12156@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408130346.GA12156@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08 2009, Christoph Hellwig wrote:
> On Wed, Apr 08, 2009 at 02:00:04PM +0200, Jens Axboe wrote:
> > This is (again) a preparatory patch similar to commit
> > a2a9537ac0b37a5da6fbe7e1e9cb06c524d2a9c4. It open codes a simple
> > async way of executing do_thaw_all() out of context, so we can get
> > rid of pdflush.
> 
> Any good reason this isn't pushed upstream for 2.6.30 yet?

The previous ones ARE in 2.6.30-rc1, but this one got added after 2.6.29
was released. I'll push this one, too.

> And if someone is inclined to clean up this area some generic way to
> run sysrq tasks in user context would be great, as a lot of them need
> to.

-- 
Jens Axboe

