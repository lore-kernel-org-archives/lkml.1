Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbXJSPed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbXJSPed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbXJSPeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:34:25 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:47629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045AbXJSPeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:34:24 -0400
Date: Fri, 19 Oct 2007 08:34:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this
 morning oopses loading P4 microcode
Message-Id: <20071019083408.fafadb8d.randy.dunlap@oracle.com>
In-Reply-To: <1192789099.7389.31.camel@Homer.simpson.net>
References: <1192681533.7147.5.camel@Homer.simpson.net>
	<1192730198.7182.18.camel@Homer.simpson.net>
	<20071018223333.GD4153@implementation>
	<1192762138.6838.13.camel@Homer.simpson.net>
	<1192789099.7389.31.camel@Homer.simpson.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 12:18:19 +0200 Mike Galbraith wrote:

> On Fri, 2007-10-19 at 04:49 +0200, Mike Galbraith wrote: 
> > On Thu, 2007-10-18 at 23:33 +0100, Samuel Thibault wrote:
> > > Hi,
> > > 
> > > Mike Galbraith, le Thu 18 Oct 2007 19:56:38 +0200, a écrit :
> > > > The winner of a very long git bisect session:
> > > > 
> > > >     unicode diacritics support
> > > 
> > > Uh, I fail to see how that could have an impact, I've again checked the
> > > boundaries, it looks fine, please people have a look.
> > 
> > I too was reluctant to believe the bisect result.  But...
> 
> Weeeell now, that skepticism is indeed well founded.  It's dontdiff.  A
> diff of trees where defkeymap.c_shipped has been modified produces no
> output.  Once a working tree has been afflicted by using diff+dontdiff
> to update it, even overwriting the entire tree via git-archive doesn't
> lead to a good build unless you also touch defkeymap.c_shipped
> afterward.  In my case, the working tree remained buildable yet
> thoroughly busted through a lengthy bisect and beyond.  That bisect
> positively identified... the victim.
> 
> poo.

Yes, that's bad.  Sam has asked me to fix some dontdiff problems.
I'll try to get to it soon.  Other people can also update it....


---
~Randy
