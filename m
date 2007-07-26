Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXGZPyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXGZPyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbXGZPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:54:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60696 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbXGZPyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:54:38 -0400
Date: Thu, 26 Jul 2007 21:24:45 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Takenori Nagano <t-nagano@ah.jp.nec.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, k-miyoshi@cb.jp.nec.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
Message-ID: <20070726155444.GC15969@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de> <20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070726154718.GA25561@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 05:47:18PM +0200, Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:44]:
> > > 
> > > Of course, but that's why the patch doesn't change this by default but
> > > gives the user the choice.
> > > 
> > 
> > What value will distro set it to by default?
> 
> 0.
> 
> > Can we be more specific in terms of functionality and code that exactly
> > what we are trying to do after panic?
> 
> Well, KDB, but now everybody answers with “not mainline -- doesn't
> count”.
> 

That's true. Its not mainline. We had similar discussion in the past
also. I think we should allow only audited code to be run after panic().
Leaving it open to modules or unaudited code makes this solution
something like LKCD where whole lot of code used to run after the crash,
hence was unreliable.

If KDB goes mainline, then I think it is not a bad idea to call debugger
first (if it is enabled) and then one can trigger crash dump from inside
the debugger.

Thanks
Vivek
