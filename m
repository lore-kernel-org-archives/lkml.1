Return-Path: <linux-kernel-owner+w=401wt.eu-S1030954AbXEAF2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030954AbXEAF2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030965AbXEAF2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:28:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:37983 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030954AbXEAF2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:28:15 -0400
Date: Tue, 1 May 2007 08:25:55 +0200
From: Andi Kleen <ak@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: vgoyal@in.ibm.com, Andi Kleen <ak@suse.de>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, Horms <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Message-ID: <20070501062554.GT25929@bingen.suse.de>
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com> <200704301717.08230.ak@suse.de> <20070501035539.GA15472@in.ibm.com> <m14pmx18ey.fsf@ebiederm.dsl.xmission.com> <20070501050657.GA23111@in.ibm.com> <m1zm4pyuzp.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zm4pyuzp.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:26:50PM -0600, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@in.ibm.com> writes:
> 
> 
> >> At least without a core file it is working on with gdb 6.4.
> >>
> >
> > This seems to be a problem with gdb 6.5. I transferred the dump to a
> > different machine having GNU gdb 6.4, and it works fine there.
> 
> Ok.  The difference between those two symbols didn't seem to make
> any sense, so a gdb bug makes sense.
> 
> Cool.  Then the patch is good. :)

It would still make any gdb 6.5 users unhappy. If no workaround can be found
I guess we'll need a CONFIG of some sort?

-Andi
