Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYG3Inc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYG3Inc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYG3InZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:43:25 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:35002 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbYG3InY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:43:24 -0400
Date: Wed, 30 Jul 2008 10:44:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: petkovbb@gmail.com, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Message-ID: <20080730084405.GD18366@uranus.ravnborg.org>
References: <12173619152424@xenotime.net> <20080729202732.GB6007@gollum.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729202732.GB6007@gollum.tnic>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:27:32PM +0200, Borislav Petkov wrote:
> On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Currently source files in the Documentation/ sub-dir can easily bit-rot
> > since they are not generally buildable, either because they are hidden
> > in text files or because there are no Makefile rules for them.
> > This needs to be fixed so that the source files remain usable and good
> > examples of code instead of bad examples.
> > 
> > Add the ability to build source files that are in the Documentation/ dir.
> > Add to Kconfig as "BUILD_DOCSRC" config symbol.
> > 
> > Use "CONFIG_BUILD_DOCSRC=1 make ..." to build objects from the
> > Documentation/ sources.  Or enable BUILD_DOCSRC in the *config system.
> 
> How about simply adding another makefile target instead? This is more
> intuitive, imho, and complies with the Kbuild conventions so far.
> Something like:
> 
> make docsrc
> 
> similar to 'make help' or 'make pdfdocs' etc.

With the current approach we have much better build coverage.
All "allyesconfig" and "allmodconfig" builds will do the test
builds which is a good think.
If we introduce "make docsrc" then almost only Randy will do the
test builds and report the breakage - which is not good.

	Sam
