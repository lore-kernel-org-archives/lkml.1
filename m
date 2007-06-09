Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbXFIFrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbXFIFrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbXFIFrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:47:36 -0400
Received: from bay0-omc1-s6.bay0.hotmail.com ([65.54.246.78]:37495 "EHLO
	bay0-omc1-s6.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbXFIFrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:47:35 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 01:46:44 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Message-Id: <20070609014644.9ed4fa29.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de>
	<200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 05:47:34.0306 (UTC) FILETIME=[AD80D020:01C7AA59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 22:18:40 -0700 (PDT)
david@lang.hm wrote:

> the way I would describe the difference betwen AA and SELinux is:
> 
> SELinux is like a default allow IPS system, you have to describe 
> EVERYTHING to the system so that it knows what to allow and what to stop.
> 
> AA is like a default deny firewall, you describe what you want to happen, 
> and it blocks everything else without you even having to realize that it's 
> there.
> 
> now I know that this isn't a perfect analyogy, that SELinux doesn't allow 
> something to happen unless it's been told to let it, but in terms of 
> complexity and the amount of work to configure things I think the analogy 
> is close.

It must be drop dead simple to modify SELinux to be default-deny.  That
seems like it could be done in a small patch instead of requiring a huge
new infrastructure.

Let's assume that everyone agrees that AA is a good idea.  Which parts of it
absolutely can't be implemented in terms of SELinux?  SELinux isn't fixed in
stone, it can be altered if necessary to accommodate AA (as in the example
above of becoming default-deny).

Sean.
