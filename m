Return-Path: <linux-kernel-owner+w=401wt.eu-S2992702AbXDTIyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992702AbXDTIyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992695AbXDTIyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:54:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:53046 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992702AbXDTIyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:54:07 -0400
Subject: Re: [PATCH] macintosh/therm_windtunnel.c: Convert to kthread API.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070419163740.9035654d.akpm@linux-foundation.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769695873569-git-send-email-ebiederm@xmission.com>
	 <20070419163740.9035654d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 18:53:00 +1000
Message-Id: <1177059180.6080.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 16:37 -0700, Andrew Morton wrote:
> On Thu, 19 Apr 2007 01:58:48 -0600
> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> 
> > Start the g4fand using kthread_run not a combination
> > of kernel_thread and deamonize.  This makes the code
> > a little simpler and more maintainable.
> 
> I had a bit of trouble reviewing this one because I was laughing so hard at
> the attempted coding-style in that driver.  Oh well.

Heh

> I continue creeping into Christoph's camp - there's quite a bit of
> open-coded gunk which would go away if we were to teach this driver about
> kthread_should_stop() and kthread_stop(), and the conversion looks awfully
> easy to do.  It's a shame to stop here.
> 
> Oh well, I guess at least this is some forward progress.

My main problem with touching that driver is that I don't have the
hardware to test. I'll try to find a user to play the ginea pig.

Ben.


