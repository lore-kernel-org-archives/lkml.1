Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXFWKp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXFWKp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXFWKpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:45:49 -0400
Received: from server145.whmcpanel.net ([69.72.254.178]:51470 "EHLO
	server459.whmcpanel.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXFWKps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:45:48 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: Question about fair schedulers
Date: Sat, 23 Jun 2007 12:45:30 +0200
User-Agent: KMail/1.9.7
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706230007.15622.info@gnebu.es> <200706231118.43408.info@gnebu.es> <20070623103012.GC7070@1wt.eu>
In-Reply-To: <20070623103012.GC7070@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231245.30317.info@gnebu.es>
X-PopBeforeSMTPSenders: info@gnebu.es
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server459.whmcpanel.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, Willy Tarreau wrote:

> > But the bottom line is that on a desktop, tasks should receive
> > different -unfair- amounts of CPU time to work correctly. The "fair"
> > concept still looks wrong to me.
>
> "fair" means what it means : stop starving some tasks for no apparent
> reasons. If one task adjusts its priority, it can get more CPU than others,
> but the distribution will still be fair according to the priorities.

Ok, this was the kind of technical explanation I was looking for, thanks.

> > Nicing tasks might not be hard at all, but expecting normal users to do
> > so is not realistic. Either the scheduler or the applications should make
> > these decisions for them (us).
>
> No, I cannot agree with you. The users have to solutions to start their
> player: - typing "mplayer xxx.mpeg" on the command line ; then they can
> prepend "nice" in front of it
>
>   - clicking on an icon in their windows-like window managers, which makes
>     executes the command for them.
>
> If they decide to use the second solution, it means that the default
> settings assigned to the icon should fit the application (that applies to
> the nice value too). And if their distro ships with those pre-defined icons
> with stupid priorities, they should complain to the distro vendor or switch
> to another one. And if the window manager by itself does not make it easy
> to adjust priorities when starting processes, it's poorly designed because
> it is it and only it which forces the user to open a command line and
> manually set "nice".
>
> So there are plenty of really transparent solutions for the user, but maybe
> there are a lot of wrong tools and configurations...

Ok, so if I understand correctly, the problem I had in my simple test will be 
solved by distributions once a fair scheduler goes into mainline? This is 
fine then. As long as someone (but not end users) takes care of giving the 
right priority to tasks of different nature it should work fine.

> Regards,
> Willy

Thank you !
Alberto.


