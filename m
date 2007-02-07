Return-Path: <linux-kernel-owner+w=401wt.eu-S1030638AbXBGRzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030638AbXBGRzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030287AbXBGRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:54:57 -0500
Received: from raven.upol.cz ([158.194.120.4]:43125 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188AbXBGRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:54:55 -0500
Date: Wed, 7 Feb 2007 19:03:24 +0100
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files
Message-ID: <20070207180324.GE1160@flower.upol.cz>
References: <20070206011819.160359000@flower.upol.cz> <20070206012208.050237000@flower.upol.cz> <Pine.LNX.4.64.0702071537530.14457@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702071537530.14457@scrub.home>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 03:39:38PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Tue, 6 Feb 2007, Oleg Verych wrote:
> 
> > -nullstring :=
> > -space      := $(nullstring) # end of line
> > +pattern = ".*/localversion[^~]*"
> > +string  = $(shell cat /dev/null \
> > +	   `find $(objtree) $(srctree) -maxdepth 1 -regex $(pattern) | sort`)
> 
> Calling find here is overkill, if the same can be done with standard make 
> functions. I very much prefer to just add the damn $(notdir ...) and be 
> done with it.

Yes? I whould insist on it as separation of "meat" from "flies", i.e
paths from files, instead of (ugly) reparsing. But you know better.

Thanks.

____
