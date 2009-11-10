Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZKJSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZKJSh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZKJSh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:37:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbZKJSh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:37:26 -0500
Date: Tue, 10 Nov 2009 19:37:30 +0100
From: Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jan Kara <jack@suse.cz>,
       jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
Message-ID: <20091110183730.GA27326@duck.suse.cz>
References: <20091026172012.GC7233@duck.suse.cz> <x49zl7020mr.fsf@segfault.boston.devel.redhat.com> <4e5e476b0911051500j7587dd6dh975148475418efcf@mail.gmail.com> <x494op7ivtu.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x494op7ivtu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-11-09 09:14:53, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > Hi Jeff,
> > what hardware are you using for tests?
> > I see aggregated random read bandwidth is larger than sequential read
> > bandwidth, and write bandwidth greater than read.
> > Is this a SAN with multiple independent spindles?
> 
> Yeah, this is a single path to an HP EVA storage array.  There are 24 or
> so disks striped in the pool used to create the volume I am using.  Jan,
> could you repeat your tests with /sys/block/sdX/queue/iosched/low_latency
> set to 0?
  I'll give it a spin tomorrow...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
