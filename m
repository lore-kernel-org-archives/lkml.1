Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbZD0ND7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbZD0ND7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 09:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZD0NDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 09:03:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41809 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbZD0NDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 09:03:49 -0400
Date: Mon, 27 Apr 2009 09:03:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com, vgoyal@redhat.com, fernando@oss.ntt.co.jp,
       linux-kernel@vger.kernel.org, jmoyer@redhat.com, jens.axboe@oracle.com,
       nauman@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com
Subject: Re: dm-ioband: Test results.
Message-ID: <20090427130331.GB3872@redhat.com>
References: <20090421141607.GA22619@redhat.com> <20090422.121443.104042516.ryov@valinux.co.jp> <20090422151805.GC32602@redhat.com> <20090427.193006.112614137.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427.193006.112614137.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27 2009 at  6:30am -0400,
Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> Hi Mike,
> 
> > Why is it that you repeatedly ignore concern/discussion about your
> > determination to continue using a custom grouping mechanism?  It is this
> > type of excess layering that serves no purpose other than to facilitate
> > out-of-tree use-cases.  dm-ioband would take a big step closer to being
> > merged upstream if you took others' feedback and showed more willingness
> > to work through the outstanding issues.
> 
> I think dm-ioband's approach is one simple way to handle cgroup
> because the current cgroup has no way to manage kernel module's
> resources. Please tell me if you have any good ideas to handle 
> cgroup by dm-ioband.

If you'd like to keep dm-ioband modular then I'd say the appropriate
cgroup interfaces need to be exposed for module use (symbols exported,
etc).  No other controller has had a need to be modular but if you think
it is requirement for dm-ioband (facilitate updates, etc) then I have to
believe it is doable.

Mike
