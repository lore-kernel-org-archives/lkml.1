Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXI1QhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXI1QhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbXI1Qgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:36:52 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:44626 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750933AbXI1Qgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:36:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Q8H41o0su6S1tmd+wQdQy5Y/u776boh3ybUWanycGklN8e1WSY2apCu/WrpO5ftKQwoxTviGUn2ihUldNjWVyU2rSWXVk4fn4eHj6K+ZXXtYYnyOFmidXypjzS6d3U+H9S6w1eANS7JndyXKRRPHBg9xau+2djZKY1EUgEeRRAI=  ;
X-YMail-OSG: hy77dkUVM1lza4zz5h0iMA8kN8KmAEkIUfMmCUaP6YB5Itbux_ESh1Zc3dE897GDEntKteifgA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Date: Fri, 28 Sep 2007 10:05:33 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
References: <20070918080537.GA14882@devil> <200709280740.40163.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281005.34001.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 00:34, Linus Torvalds wrote:
> On Fri, 28 Sep 2007, Nick Piggin wrote:
> > > God I hate select.
> >
> > IMO a better implementation would result in a notification / confirmation
> > of turning on new items, and the ability to deselect options which will
> > also confirm to deselect dependants. Like most other systems that have
> > similar problem to solve.
>
> Actually, the *really* nice thing to do would be to just add the reason
> something got enabled into the ".config" file.
>
> IOW, wouldn't it be nice if the .config file just said
>
> 	...
> 	CONFIG_ACPI=y		# selected by X86_64_ACPI_NUMA
> 	CONFIG_ACPI_PROCFS=y	# user choice
> 	...
>
> etc, since the config process actually does know these things?

Sure, that would probably be pretty trivial to implement too, and
would solve most problems for kernel devs.

At a level up from that, I think ease of use could be improved with
a package manager-type chained-selection/deselection feature in
the config tools.

Not that I'm volunteering to implement either ;)

>
> That way, there's always a fairly straightforward way to see why some
> configuration is the way it is (and the .config file is not only useful
> for "make oldconfig", it's also what normally gets passed around for bug
> reports, and is part of distro kernel packages etc, so it would seem to be
> the right place, no?)
>
> 		Linus
