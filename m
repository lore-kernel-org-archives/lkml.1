Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbXEDGEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbXEDGEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbXEDGEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:04:15 -0400
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:38334 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588AbXEDGEO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:04:14 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 02:04:14 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=TJjyOrG+8dgeZnlbCS8mFnL5Igh5EaE6y0x7fljVaKeiZxv9iaZ3gsuHSbXyDM0I;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Fri, 4 May 2007 01:54:43 -0400
From: Bill Fink <billfink@mindspring.com>
To: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Olaf Hering <olh@suse.de>,
       akpm@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org
Subject: Re: [git pull] New firewire stack
Message-Id: <20070504015443.43fd4544.billfink@mindspring.com>
In-Reply-To: <463A1CD3.2060200@redhat.com>
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au>
	<46399BDE.4040605@s5r6.in-berlin.de>
	<20070503114854.GA12731@suse.de>
	<4639E3FC.8060107@s5r6.in-berlin.de>
	<20070503163442.GK3531@stusta.de>
	<463A1CD3.2060200@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dbac26fbc3ae365eedb2e81a1e06e035d350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.55.21.22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 May 2007, Kristian Høgsberg wrote:

> Adrian Bunk wrote:
> >> | An advantage of changing the names is that they are now prefixed.
> >>
> >> Is the opportunity to clean up module names compelling enough, vs. (the
> >> wish for) minimized trouble with scripts which refer to module names?
> >> ...
> > 
> > How big is the trouble actually?
> 
> Exactly.  In Fedora we've just added a fw-sbp2 case to mkinitrd, it's only a 
> couple of lines of extra shell code:
> 
>      elif [ "$modName" = "fw-sbp2" ]; then
>          findmodule fw-core
>          findmodule fw-ohci
>          modName="fw-sbp2"
> 
> and that's the extent of the changes.  The sbp2 case for the old drivers is 
> still in there and in the end mkinitrd works with either stack.
> 
> Kristian

I also think both stacks should be provided in the mainline kernel,
preferably in their own separate directories.  I still need the old
stack for dv1394, which isn't available in the new stack.  But if
the new stack is also there, I might be motivated for example to try
out the new sbp2 module, to see how well it works and how it compares
in performance to the old sbp2 module.  If it's not there, I'm probably
not going to go out of my way to download it from the net, since my
existing setup is working just fine for me.

						-Bill
