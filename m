Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZFWLpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZFWLpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 07:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZFWLpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 07:45:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47467 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZFWLpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 07:45:05 -0400
Date: Tue, 23 Jun 2009 14:44:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH RFC] pass write value to in_range pointers
Message-ID: <20090623114438.GD17635@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net> <20090622151631.GA14780@redhat.com> <4A3FA6FC.9030301@novell.com> <20090622160833.GA15228@redhat.com> <4A3FB156.3030301@novell.com> <20090622172720.GC15228@redhat.com> <4A405436.1080100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A405436.1080100@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 12:04:06AM -0400, Gregory Haskins wrote:
> >>  It will also need to support
> >> multiple matches.
> >>     
> >
> > What, signal many fds on the same address/value pair?
> > I see this as a bug. Why is this a good thing to support?
> > Just increases the chance of leaking this fd.
> >   
> 
> I believe Avi asked for this feature specifically, so I will defer to him.

Hmm. That's hard to implement in my model. Avi, can we give up
this feature? I don't think anyone needs this specifically ...

-- 
MST
