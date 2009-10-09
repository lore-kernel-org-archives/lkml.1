Return-Path: <linux-kernel-owner+w=401wt.eu-S934635AbZJIXqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbZJIXqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934626AbZJIXqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:46:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934625AbZJIXqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:46:32 -0400
Date: Fri, 9 Oct 2009 19:45:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
Message-ID: <20091009234555.GA28257@infradead.org>
References: <20091009160115.GA2647@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009160115.GA2647@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 12:01:16PM -0400, Jason Baron wrote:
> hi,
> 
> I'd like to move the gfs2 tracepoints to the the common
> include/trace/events directory along with all of the other trace events.
> It makes understanding what tracepoints are available easier, and I see
> no reason why gfs2 should be different. For example, 'ext4.h' is already
> in the include/trace/events directory.

Folks, no.  Drivers and filesystems should be as self-contained as
possible.  include/trace/ is an extremly bad idea for everything that's
not actually global kernel functionality.  There's a reason all other
fs headers have moved out of include/linux, too.

