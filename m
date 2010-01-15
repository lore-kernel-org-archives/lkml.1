Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab0AOVd3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304Ab0AOVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:33:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab0AOVd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:33:27 -0500
Subject: Re: [PATCH] idr: fix idr corruption when id crosses a layer
 boundary
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, miltonm@austin.ibm.com,
        penberg@cs.helsinki.fi, bharata@linux.vnet.ibm.com, jkosina@suse.cz
In-Reply-To: <20100115132432.88037419.akpm@linux-foundation.org>
References: <1263590090-24967-1-git-send-email-eparis@redhat.com>
	 <20100115132432.88037419.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 16:32:57 -0500
Message-ID: <1263591177.14495.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 13:24 -0800, Andrew Morton wrote:
> On Fri, 15 Jan 2010 16:14:50 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > inotify has for months been been having problems keeping the fsnotify view of
> > its objects in sync with the idr view of its objects.  I discovered this was
> > only ever the case with the 4096th object created.
> 
> Neato.  Do you think this will help with all the inotify problems
> people have been having?

I do believe it should shut up the inotify WARN() people have been
seeing and the memory leak....

> Do you think this fix should go into 2.6.32.x and earlier?

If someone who really understands the idr and can explain the original
test that was there thinks it right I think it should.  It's been broken
and able to produce corruption for a long time.

-Eric

