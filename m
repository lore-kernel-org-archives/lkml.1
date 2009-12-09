Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbZLIUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbZLIUjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbZLIUjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757752AbZLIUjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:39:41 -0500
Date: Wed, 9 Dec 2009 15:39:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       guijianfeng@cn.fujitsu.com
Subject: Re: [PATCH 2/2] cfq-iosched: Take care of corner cases of group
	losing share due to deletion
Message-ID: <20091209203941.GA2738@redhat.com>
References: <1260312778-4725-1-git-send-email-vgoyal@redhat.com> <1260312778-4725-2-git-send-email-vgoyal@redhat.com> <20091209135639.GW8742@kernel.dk> <20091209151723.GA8452@redhat.com> <x49bpi8nf19.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49bpi8nf19.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 02:06:10PM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com> 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> > +	/*
> > +	 * If think times is less than a jiffy than ttime_mean=0 and above
> > +	 * will not be true. It might happen that slice has not expired yet
> > +	 * but will expire soon (4-5 ns) during select_queue(). To cover the
> 
> 4-5ns?  I'm not sure why you chose these numbers.  Is that what you saw
> in testing?

Yes, that was the number I observed in blktrace while I was debugging
the issue.

>  Anyway, I'm ok with the change, I dislike the reference to
> time when a single jiffy could be up to 10ms.
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
