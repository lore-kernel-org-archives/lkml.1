Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbZAYTQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbZAYTQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 14:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZAYTQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 14:16:32 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36107 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZAYTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 14:16:32 -0500
Date: Sun, 25 Jan 2009 20:18:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Satish Eerpini <eerpini@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: building custom module on 2.6.28 fails
Message-ID: <20090125191816.GA31368@uranus.ravnborg.org>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com> <1232866165.3195.1.camel@localhost.localdomain> <93655eb70901250037k79286904oc859118946155766@mail.gmail.com> <1232879436.4303.40.camel@localhost.localdomain> <1232880058.4303.46.camel@localhost.localdomain> <93655eb70901250319m334665bew9b5f6738ba6282a7@mail.gmail.com> <20090125134712.GA29757@uranus.ravnborg.org> <1232893657.10647.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232893657.10647.4.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 07:57:37PM +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-01-25 at 14:47 +0100, Sam Ravnborg wrote:
> > On Sun, Jan 25, 2009 at 04:49:16PM +0530, Satish Eerpini wrote:
> > > >> It seems you run "make clean" or "make distclean" in your kernel sources
> > > >>
> > > >> run "make prepare" in your kernel sources then you will not get this
> > > >> error.
> > > >
> > > 
> > > I ran make clean and then make prepare but it gives an error saying
> > > "no such file or directory : modpost ", ....
> > > Then i ran make( in the kernel source tree) , and terminated it after
> > > a few files were compiled and then again tried to compile my module,
> > > this time it worked without any errors, ....... any particular reason
> > > for this ??
> > We are currently lacking a dependency on "scripts" so doing:
> > make scripts
> > make prepare
> > is needed today.
> 
> As per makefile:
> # make clean     Delete most generated files
> #                Leave enough to build external modules
> 
> So is this OK to delete include/linux/bounds.h by 'make clean'.
No - only mrproper and distclean should delete it.

	Sam
