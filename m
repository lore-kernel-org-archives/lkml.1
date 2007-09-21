Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbXIUNva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbXIUNva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbXIUNvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:51:13 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:59223 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709AbXIUNvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:51:11 -0400
Date: Fri, 21 Sep 2007 09:46:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 4/4] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070921134602.GG13129@Krystal>
References: <20070918211324.161373216@polymtl.ca> <20070918211500.117442517@polymtl.ca> <20070921010338.GB4951@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070921010338.GB4951@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:45:55 up 53 days, 14:04,  4 users,  load average: 0.44, 0.68, 0.71
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, Sep 18, 2007 at 05:13:28PM -0400, Mathieu Desnoyers wrote:
> > +void blk_probe_disarm(void)
> > +{
> > +	int i, err;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(probe_array); i++) {
> > +		err = marker_disarm(probe_array[i].name);
> > +		BUG_ON(err);
> > +		err = IS_ERR(marker_probe_unregister(probe_array[i].name));
> > +		BUG_ON(err);
> > +	}
> > +}
> 
> As well as changing these to WARN_ON.
> 
Yep.

> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
