Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYH0U5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYH0U5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYH0U5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:57:43 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43003 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbYH0U5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:57:42 -0400
Subject: Re: [RFC v2][PATCH 4/9] Memory management - dump state
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080827204853.GA4189@us.ibm.com>
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0808202304490.17436@takamine.ncl.cs.columbia.edu>
	 <1219437422.20559.146.camel@nimitz> <48B0F449.2000006@cs.columbia.edu>
	 <1219768406.8680.17.camel@nimitz> <48B49C61.1040003@cs.columbia.edu>
	 <1219851696.8680.67.camel@nimitz> <20080827203427.GA1158@us.ibm.com>
	 <1219869510.8680.90.camel@nimitz>  <20080827204853.GA4189@us.ibm.com>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 13:56:16 -0700
Message-Id: <1219870576.8680.96.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 15:48 -0500, Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > On Wed, 2008-08-27 at 15:34 -0500, Serge E. Hallyn wrote:
> > > (Or, is that too much effort required on your part to try and
> > > cherrypick bits of Oren's changes back into your tree?)
> > 
> > That would probably work as long as Oren is working on top of what I
> > have.  It's going to be a lot harder if I have to repeat the same
> > break-out process for each iteration of Oren's patches, though.
> > 
> 
> If Oren's purpose is not quite to create a upstreamable patchset,
> then it would make more sense for him to keep a git tree and
> put new patches on top of his existing ones (within reaason as he
> rebases).  Then you'd at least be able to trivially look at the latest
> deltas.

The trick would be compromising on things that I, for instance, think
need to be rewritten or removed.

Oren would have to rebase his work against what I do.  I guess you could
think about it like me being upstream from Oren.  Anything that I would
change, Oren would need to rebase on top of.

Oren, are you willing to keep a set of patches that add functionality on
top of a minimal set that I'm keeping?  Mine being the set that we're
trying to push into mainline as soon as possible.

-- Dave

