Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZAKTIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZAKTIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZAKTIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:08:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38150 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZAKTIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:08:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Date: Sun, 11 Jan 2009 20:07:54 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Igor M. Liplianin" <liplianin@me.by>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
References: <200901031247.14977.rjw@sisk.pl> <20090104214406.GA31668@uranus.ravnborg.org> <1231598216.5806.124.camel@macbook.infradead.org>
In-Reply-To: <1231598216.5806.124.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901112007.55178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2009, David Woodhouse wrote:
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
> 
> Your patch seems to have broken the Fedora kernel build for 'noarch',
> which runs 'make firmware_install' without building a kernel.
> 
> Rafael, if you revert Sam's fix and also revert 4b29631d, does it work
> again?

Deosn't revert, sorry.

Can you send me a standalone fix patch to test, please?

Rafael
