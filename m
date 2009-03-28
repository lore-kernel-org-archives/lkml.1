Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZC1Wi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZC1Wi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZC1WiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:38:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZC1WiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:38:08 -0400
Date: Sat, 28 Mar 2009 22:37:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328223740.GD28946@ZenIV.linux.org.uk>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CEA3CD.105@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 03:25:17PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > 
> > Ordering include based on length of line minimize the
> > risk of merge conflicts.
> > If people just add new includes in the bottom of the list you
> > are certain that a merge conflit happens.
> > 
> > This scheme is starting to be used in several places with the
> > primary advocates being David Miller and Ingo.
> > 
> > It is getting used both for includes _and_ for local variables.
> > 
> 
> Personally I'd prefer alphabetic order, sorting based on length isn't a
> complete ordering.  Nearly all editors can sort alphabetically at the
> push of a key.

*shrug*

FWIW, the real problem is that we have far too many includes in a typical
file; the ordering wouldn't matter if there would be 4-5 #include in
foo.c.  Inventing elaborate policies to cope with that crap instead of
addressing the root cause (namely, cut'n'paste approach to includes) is
rather pointless...
