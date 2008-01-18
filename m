Return-Path: <linux-kernel-owner+w=401wt.eu-S1763300AbYARUSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763300AbYARUSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYARUSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:18:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:52089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbYARUSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:18:43 -0500
Date: Fri, 18 Jan 2008 12:19:26 -0800
From: Greg KH <gregkh@suse.de>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, prasanna@in.ibm.com,
       ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net
Subject: Re: BUG? 2.6.24-rc*[-mm*] - debugfs subdirs missing on x86_64
Message-ID: <20080118201926.GA24225@suse.de>
References: <1200687154.5043.100.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200687154.5043.100.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 03:12:33PM -0500, Lee Schermerhorn wrote:
> I searched around the archives and web and didn't find any reports on
> this [maybe just missed them?], so I MUST be doing something
> wrong/stupid.  My config [included] may be the culprit.  Apologies for
> the long cc list.  I'm copying the kprobes and blktrace maintainers
> [addresses from MAINTAINERS] to verify that they're NOT seeing this
> problem.
> 
> Problem:  I see no sub-directories below /sys/kernel/debug on x86_64

Have you mounted debugfs on /sys/kernel/debug?  Try:
	mount -t debugfs none /sys/kernel/debug
as root and see if the files are present or not.

thanks,

greg k-h
