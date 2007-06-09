Return-Path: <linux-kernel-owner+w=401wt.eu-S1032533AbXFIAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032533AbXFIAR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030974AbXFIARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:17:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58428 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969960AbXFIARO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:17:14 -0400
Date: Fri, 8 Jun 2007 17:17:03 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070609001703.GA17644@kroah.com>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706090003.57722.agruen@suse.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 12:03:57AM +0200, Andreas Gruenbacher wrote:
> AppArmor is meant to be relatively easy to understand, manage, and customize, 
> and introducing a labels layer wouldn't help these goals.

Woah, that describes the userspace side of AA just fine, it means
nothing when it comes to the in-kernel implementation.  There is no
reason that you can't implement the same functionality using some
totally different in-kernel solution if possible.

> SELinux is applicable in areas where AppArmor is not (e.g., MLS), but
> this comes at a cost. For me the question is not SELinux or AppArmor,
> but if AppArmor's security model is a good solution in common
> scenarios. In my opinion, AppArmor is a better answer than SELinux in
> a number of scenarios. This gives it value, nonwithstanding the fact
> that SELinux can be taken further.

I am still not completely certian that we can not properly implement AA
functionality using a SELinux backend solution.  Yes, the current tools
that try to implement this are still lacking, and maybe the kernel needs
to change, but that is possible.

I still want to see a definition of the AA "model" that we can then use
to try to implement using whatever solution works best.  As that seems
to be missing the current argument of if AA can or can not be
implemented using SELinux or something totally different should be
stopped.

So, AA developers, do you have such a document anywhere?  I know there
are some old research papers, do they properly describe the current
model you are trying to implement here?

thanks,

greg k-h
