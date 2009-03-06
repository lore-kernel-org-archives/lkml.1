Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZCFQXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZCFQXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 11:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZCFQXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 11:23:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38681 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbZCFQXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 11:23:41 -0500
Date: Fri, 6 Mar 2009 10:23:37 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090306162337.GA3040@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236291865.22399.139.camel@nimitz> <20090306143425.GA31250@us.ibm.com> <1236354509.10626.29.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236354509.10626.29.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Fri, 2009-03-06 at 08:34 -0600, Serge E. Hallyn wrote:
> > > > With time the amount of stuff C/R won't support will approach zero,
> > > > but the infrastructure for "checkpointable" will stay constant.
> > > > If it's too much right now, it will be way too much in future.
> > > 
> > > What have you seen in OpenVZ?  Do new things that are not checkpointable
> > > pop up very often?
> > 
> > Realistically, do you think the uncheckpointable stuff would catch a
> > brand-new unsupported feature?  If it has a file interface then I
> > suppose it would.  Well, might.  I wouldn't be surprised if the authors
> > would cut and paste enough code to paste the .checkpoint =
> > generic_file_checkpoint line :)
> 
> Yeah, that's true.  Us maintainers would probably need to keep an eye on
> that.

Which imo is fine, but my question is whether that leaves any actual
value in the persistent per-resource uncheckpointable flag.

-serge
