Return-Path: <linux-kernel-owner+w=401wt.eu-S932317AbZDHNKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbZDHNKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbZDHNDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765395AbZDHNDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:49 -0400
Date: Wed, 8 Apr 2009 09:03:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 01/13] buffer: switch do_emergency_thaw() away from
	pdflush_operation()
Message-ID: <20090408130346.GA12156@infradead.org>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com> <1239192016-19857-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239192016-19857-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 02:00:04PM +0200, Jens Axboe wrote:
> This is (again) a preparatory patch similar to commit
> a2a9537ac0b37a5da6fbe7e1e9cb06c524d2a9c4. It open codes a simple
> async way of executing do_thaw_all() out of context, so we can get
> rid of pdflush.

Any good reason this isn't pushed upstream for 2.6.30 yet?

And if someone is inclined to clean up this area some generic way to
run sysrq tasks in user context would be great, as a lot of them need
to.
