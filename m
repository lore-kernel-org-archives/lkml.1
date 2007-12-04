Return-Path: <linux-kernel-owner+w=401wt.eu-S1752405AbXLDUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752405AbXLDUY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXLDUYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:24:49 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39284 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXLDUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:24:48 -0500
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071204200558.GB1988@Krystal>
References: <20071129023421.GA711@Krystal>
	 <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal>
	 <1196444801.18851.127.camel@localhost> <20071130170516.GA31586@Krystal>
	 <1196448122.19681.16.camel@localhost> <20071130191006.GB3955@Krystal>
	 <y0mve7ez2y3.fsf@ton.toronto.redhat.com> <20071204192537.GC31752@Krystal>
	 <1196797259.6073.17.camel@localhost>  <20071204200558.GB1988@Krystal>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:24:23 -0800
Message-Id: <1196799863.6073.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 15:05 -0500, Mathieu Desnoyers wrote:
> * Dave Hansen (haveblue@us.ibm.com) wrote:
> > On Tue, 2007-12-04 at 14:25 -0500, Mathieu Desnoyers wrote:
> > > 
> > > - I also dump the equivalent of /proc/swaps (with kernel internal
> > >   information) at trace start to know what swap files are currently
> > >   used.
> > 
> > What about just enhancing /proc/swaps so that this information can be
> > useful to people other than those doing traces?
> 
> It includes an in-kernel struct file pointer, exporting it to userspace
> would be somewhat ugly.

What about just exporting the 'type' field that we use to index into
swap_info[]?

As far as /proc goes, it may not be _ideal_ for your traces, but it sure
beats not getting the information out at all. ;)  I guess I'm just not
that familiar with the tracing requirements and I can't really assess
whether what you're asking for is reasonable, or horrible
over-engineering.  Dunno.

-- Dave

