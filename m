Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYAYXQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYAYXQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbYAYXQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:16:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:53631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761392AbYAYXNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:13:05 -0500
Date: Fri, 25 Jan 2008 15:10:40 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-ID: <20080125231040.GC25074@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-104-git-send-email-gregkh@suse.de> <20080125222530.GA23769@elte.hu> <20080125223858.GA15723@suse.de> <20080125225723.GA26475@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125225723.GA26475@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:57:23PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> > > Changes like this (and it now leaked into Linus' tree as well) kill 
> > > bisectability.
> > 
> > The odds that a "normal" person has sysfs turned off and modules 
> > enabled, trying to bisect things, is pretty slim :)
> 
> that "slim" combination is what i use for about 25% of all my bisections 
> - i build, boot and stress-test randconfig configs.
> 
> If i find a problem with a given .config, i do _not_ go around and 
> change the .config to make a bisection point work. (and the automated 
> bisection scripts definitely wont do it either.)
> 
> so what is a 'weird config' to you is a real testing barrier for others. 
> And crap like that quickly mounts up. Having a buildable and bootable 
> kernel at every bisection point is a _must_.
> 
> Please! :-)

Yes, I do agree that this is important, I'll work to not let this happen
again.  Especially now that I have your build scripts, I'm working on
setting up something like that myself here.

thanks,

greg k-h
