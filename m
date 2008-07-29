Return-Path: <linux-kernel-owner+w=401wt.eu-S1760606AbYG2VLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606AbYG2VLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYG2VKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:10:53 -0400
Received: from xenotime.net ([66.160.160.81]:42555 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752765AbYG2VKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:10:52 -0400
Date: Tue, 29 Jul 2008 14:10:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: petkovbb@gmail.com
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] docsrc: build Documentation/ sources
Message-Id: <20080729141045.9341663b.rdunlap@xenotime.net>
In-Reply-To: <20080729202732.GB6007@gollum.tnic>
References: <12173619152424@xenotime.net>
	<20080729202732.GB6007@gollum.tnic>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 22:27:32 +0200 Borislav Petkov wrote:

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

Hi Boris,

I happen to have a previous version of the patch that does that, so yes, I can
post that if that's the preferred solution.  I'll wait for other comments before
reposting.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
