Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXFAEQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXFAEQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbXFAEQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:16:23 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57377 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbXFAEQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:16:22 -0400
Date: Fri, 1 Jun 2007 06:17:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Prarit Bhargava <prarit@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, David Chinner <dgc@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at kernel/fork.c:385
Message-ID: <20070601041722.GA30506@uranus.ravnborg.org>
References: <617E1C2C70743745A92448908E030B2A01961A60@scsmsx411.amr.corp.intel.com> <465F9315.2050207@redhat.com> <Pine.LNX.4.64.0705312105280.30098@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705312105280.30098@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 09:05:54PM -0700, Christoph Lameter wrote:
> On Thu, 31 May 2007, Prarit Bhargava wrote:
> 
> > I used the sn2_defconfig in the tree :)
> 
> That is a static kernel build. Ideal for that kind of bug.
Quite the opposite.
If modpost cannot resolve symbols you are jsut told what
top-level file it is in.
A allmodconfig should be more useful and give you warnings in all normal
cases.

Let me know if I shall look over some of the warnings.

	Sam
