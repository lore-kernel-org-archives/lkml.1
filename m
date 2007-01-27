Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXA0ASd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXA0ASd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXA0ASc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:18:32 -0500
Received: from gockel.physik3.uni-rostock.de ([139.30.44.16]:27929 "EHLO
	gockel.physik3.uni-rostock.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbXA0ASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:18:32 -0500
Date: Sat, 27 Jan 2007 01:18:30 +0100 (CET)
From: Tim Schmielau <tim@physik3.uni-rostock.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
In-Reply-To: <20070126201451.GA14946@flower.upol.cz>
Message-ID: <Pine.LNX.4.63.0701270113400.4567@gockel.physik3.uni-rostock.de>
References: <200701151624.18033.rob@landley.net> <200701251438.03213.rob@landley.net>
 <20070125211802.GC10907@flower.upol.cz> <200701261247.22374.rob@landley.net>
 <20070126201451.GA14946@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Oleg Verych wrote:

> In Debian's version it has no `bc', while native `bc' is producing
> crap like that:
> ,-*- bash -*-
> |olecom@flower:~$ printf "%u" $(( -1 )) ; echo
> |18446744073709551615
> |olecom@flower:~$ echo -1 | bc
> |-1
> |olecom@flower:~$ printf "%u" $(( 0xFF )) ; echo
> |255
> |olecom@flower:~$ echo FF | bc
> |99
> |olecom@flower:~$ echo F | bc
> |15
> |olecom@flower:~$
> `-*-
> 
> i can't understand the result... I think linux/scripts/makelst may be
> updated to have sh's version of address calculation ;)

No, IMHO that should not be a reason to change anything in the kernel.
Just set ibase=16 or read the fine manual:
  info '(bc)About Expressions and Special Variables'

Tim
