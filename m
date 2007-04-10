Return-Path: <linux-kernel-owner+w=401wt.eu-S966087AbXDJFWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966087AbXDJFWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 01:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966091AbXDJFWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 01:22:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966087AbXDJFWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 01:22:04 -0400
Date: Tue, 10 Apr 2007 01:21:46 -0400
From: Dave Jones <davej@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410052146.GA23914@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <20070410050754.GB5836@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410050754.GB5836@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:07:54AM +0400, Alexey Dobriyan wrote:
 > On Mon, Apr 09, 2007 at 07:30:56PM -0700, Andrew Morton wrote:
 > > On Mon, 9 Apr 2007 21:59:12 -0400 Dave Jones <davej@redhat.com> wrote:
 > 
 > [possible topic for KS2007]
 > 
 > > >   164 ?        S<     0:00 [cqueue/0]
 > > >   165 ?        S<     0:00 [cqueue/1]
 > > >
 > > > I'm not even sure wth these are.
 > >
 > > Me either.
 > 
 > drivers/connector/connector.c:
 > 455	dev->cbdev = cn_queue_alloc_dev("cqueue", dev->nls);

Maybe I have apps relying on the connector stuff that I don't
even realise, but ttbomk, nothing actually *needs* this
for 99% of users if I'm not mistaken.

* wonders why he never built this modular..

config PROC_EVENTS
        boolean "Report process events to userspace"
        depends on CONNECTOR=y


Yay.

	Dave

-- 
http://www.codemonkey.org.uk
