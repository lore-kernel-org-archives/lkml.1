Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZJLKPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZJLKPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZJLKPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbZJLKPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:15:01 -0400
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
From: Steven Whitehouse <swhiteho@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20091012100037.GA11653@elte.hu>
References: <20091009160115.GA2647@redhat.com>
	 <20091009234555.GA28257@infradead.org>
	 <1255340583.2675.23.camel@localhost.localdomain>
	 <20091012100037.GA11653@elte.hu>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Mon, 12 Oct 2009 11:16:15 +0100
Message-Id: <1255342575.2675.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-10-12 at 12:00 +0200, Ingo Molnar wrote:
> * Steven Whitehouse <swhiteho@redhat.com> wrote:
> 
> > Hi,
> > 
> > On Fri, 2009-10-09 at 19:45 -0400, Christoph Hellwig wrote:
> > > On Fri, Oct 09, 2009 at 12:01:16PM -0400, Jason Baron wrote:
> > > > hi,
> > > > 
> > > > I'd like to move the gfs2 tracepoints to the the common
> > > > include/trace/events directory along with all of the other trace events.
> > > > It makes understanding what tracepoints are available easier, and I see
> > > > no reason why gfs2 should be different. For example, 'ext4.h' is already
> > > > in the include/trace/events directory.
> > > 
> > > Folks, no.  Drivers and filesystems should be as self-contained as
> > > possible.  include/trace/ is an extremly bad idea for everything that's
> > > not actually global kernel functionality.  There's a reason all other
> > > fs headers have moved out of include/linux, too.
> > > 
> > 
> > That true, although there is an argument about how much such a header 
> > belongs to tracing and how much it belongs to the subsystem I think.
> 
> yeah. I have no objection to adding it to include/trace/. Tracepoints 
> are a fundamentally global business.
> 
> Subsystems can opt to hide their tracepoints locally, but it's better to 
> have a global view about what's out there, so that it can be extended 
> coherently, etc.
> 
> Would you like to carry the patch or should we apply it to the tracing 
> tree?
> 
> 	Ingo

It is already in my tree, but lets wait and see what Christoph says, as
maybe we want to organise things differently. Personally I don't really
mind where we put it, so long as it makes sense and I know where it
is :-)

Steve.


