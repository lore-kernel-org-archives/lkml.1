Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXGQBKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXGQBKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbXGQBKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:10:18 -0400
Received: from ozlabs.org ([203.10.76.45]:58498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbXGQBKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:10:17 -0400
Subject: Re: maps2-move-the-page-walker-code-to-lib.patch
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070713204817.GA3529@uranus.ravnborg.org>
References: <1183873796.6005.269.camel@localhost.localdomain>
	 <20070709202217.GS11115@waste.org>
	 <1184033195.6005.439.camel@localhost.localdomain>
	 <20070713204817.GA3529@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 11:09:57 +1000
Message-Id: <1184634597.5955.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 22:48 +0200, Sam Ravnborg wrote:
> On Tue, Jul 10, 2007 at 12:06:35PM +1000, Rusty Russell wrote:
> > On Mon, 2007-07-09 at 15:22 -0500, Matt Mackall wrote:
> > > On Sun, Jul 08, 2007 at 03:49:56PM +1000, Rusty Russell wrote:
> > > > Matt wrote:
> > > > > This lets it get shared outside of proc/ and linked in only when needed.
> > > > 
> > > > Erk, this really belongs in the mm dir.  You can use "lib-y +=
> > > > pagewalk.o" there, and it seems to work as well as doing it in lib.
> > > 
> > > Are you sure? I tested that a few months ago and it didn't work for
> > > me. I seem to recall it wanted a chunk of makefile surgery.
> > 
> > Well, I tested here and it worked unless I screwed something (producing
> > lib.a in mm/ and linking it in).  And when I turned off all the CONFIG
> > options which required it, the symbols disappeared from the vmlinux...
> 
> I think you had some additional change somewhere...
> kbuild will only look for lib.a files (produced from all files
> listed with lib-y _except_ files listed with obj-y too).

You're right: mm/lib.a gets built, but not linked in.  Sorry for the
false report...

Rusty.

