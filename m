Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZAJOhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZAJOhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZAJOhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:37:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:35927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZAJOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:37:25 -0500
Subject: Re: [Regression] Build failure in current mainline - firmware
 related
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Igor M. Liplianin" <liplianin@me.by>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20090104214406.GA31668@uranus.ravnborg.org>
References: <200901031247.14977.rjw@sisk.pl>
	 <20090103204948.GA5388@uranus.ravnborg.org>
	 <20090103205437.GA5499@uranus.ravnborg.org>
	 <200901032243.28684.rjw@sisk.pl>
	 <20090104214406.GA31668@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 14:36:56 +0000
Message-Id: <1231598216.5806.124.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 22:44 +0100, Sam Ravnborg wrote:
> 
> We could try to rearrange things so we do not trigger
> the rebuild of ihex2fw in the modules_install case.
> This would likely involve creating a new file listing
> all the firmawre files and share it between firmware/Makefile
> and scripts/Makefile.fwinst

Didn't we already have that, but it got broken for some reason, by
unwanted changes in commit 4b29631db33292d416dc395c56122ea865e7635c

Your patch seems to have broken the Fedora kernel build for 'noarch',
which runs 'make firmware_install' without building a kernel.

Rafael, if you revert Sam's fix and also revert 4b29631d, does it work
again?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

