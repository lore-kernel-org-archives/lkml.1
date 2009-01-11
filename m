Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314AbZAKOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbZAKOnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZAKOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:43:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbZAKOne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:43:34 -0500
Date: Sun, 11 Jan 2009 12:42:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [Regression] Build failure in current mainline - firmware
 related
Message-ID: <20090111124250.05b6dff4@pedra.chehab.org>
In-Reply-To: <1231598216.5806.124.camel@macbook.infradead.org>
References: <200901031247.14977.rjw@sisk.pl>
	<20090103204948.GA5388@uranus.ravnborg.org>
	<20090103205437.GA5499@uranus.ravnborg.org>
	<200901032243.28684.rjw@sisk.pl>
	<20090104214406.GA31668@uranus.ravnborg.org>
	<1231598216.5806.124.camel@macbook.infradead.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 10 Jan 2009 14:36:56 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> On Sun, 2009-01-04 at 22:44 +0100, Sam Ravnborg wrote:
> > 
> > We could try to rearrange things so we do not trigger
> > the rebuild of ihex2fw in the modules_install case.
> > This would likely involve creating a new file listing
> > all the firmawre files and share it between firmware/Makefile
> > and scripts/Makefile.fwinst
> 
> Didn't we already have that, but it got broken for some reason, by
> unwanted changes in commit 4b29631db33292d416dc395c56122ea865e7635c

Sorry for that. It seems that, I've committed Igor patch with a dirty tree. So, one
patch for me to allow out-of-tree compiling were merged with the real patch
from Igor.

-- 

Cheers,
Mauro
