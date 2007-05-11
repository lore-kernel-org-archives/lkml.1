Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXEKCOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXEKCOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 22:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXEKCO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 22:14:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:33876 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXEKCO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 22:14:26 -0400
Date: Thu, 10 May 2007 21:13:34 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@gate.crashing.org
To: Simon Horman <horms@verge.net.au>, sam@ravnborg.org
cc: Timur Tabi <timur@freescale.com>,
       Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: Kconfig warnings on latest GIT
In-Reply-To: <20070511020545.GG10715@verge.net.au>
Message-ID: <Pine.LNX.4.64.0705102111570.11348@gate.crashing.org>
References: <200705080004.14570.ismail@pardus.org.tr>
 <20070508143127.38fafa3c.kim.phillips@freescale.com> <4640D988.1040504@freescale.com>
 <20070510051042.GA16812@verge.net.au> <46434ED0.6030808@freescale.com>
 <20070511012529.GC10715@verge.net.au> <Pine.LNX.4.64.0705102046400.10555@gate.crashing.org>
 <20070511020545.GG10715@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Simon Horman wrote:

> On Thu, May 10, 2007 at 08:47:05PM -0500, Kumar Gala wrote:
> > Try this patch:
>
> That certainly resolves the problem for me.
> I'll see about doing something like that for the similar
> Kconfig problems that I see.
>
> --
> Horms
>   H: http://www.vergenet.net/~horms/
>   W: http://www.valinux.co.jp/en/
>

I've got a similar fix for SYS_SUPPORTS_APM_EMULATION already.  I'll push
both of these to Paul.  If you can put something in place for the
Atari/68k and send it to Geert that would be good (feeling a little lazy
right now :)

I'm still not happy about this fix.  I'd like to get Sam's feeling on if
we can fixup kconfig not to warn if the dependency isn't meet.  I think
the select is valid, and would prefer to fix this properly before we paper
tape over it.

- k
