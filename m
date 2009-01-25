Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZAYO2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZAYO2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 09:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZAYO2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 09:28:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:41479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZAYO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 09:28:24 -0500
Subject: Re: building custom module on 2.6.28 fails
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Satish Eerpini <eerpini@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090125134712.GA29757@uranus.ravnborg.org>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
	 <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
	 <1232879436.4303.40.camel@localhost.localdomain>
	 <1232880058.4303.46.camel@localhost.localdomain>
	 <93655eb70901250319m334665bew9b5f6738ba6282a7@mail.gmail.com>
	 <20090125134712.GA29757@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 19:57:37 +0530
Message-Id: <1232893657.10647.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-25 at 14:47 +0100, Sam Ravnborg wrote:
> On Sun, Jan 25, 2009 at 04:49:16PM +0530, Satish Eerpini wrote:
> > >> It seems you run "make clean" or "make distclean" in your kernel sources
> > >>
> > >> run "make prepare" in your kernel sources then you will not get this
> > >> error.
> > >
> > 
> > I ran make clean and then make prepare but it gives an error saying
> > "no such file or directory : modpost ", ....
> > Then i ran make( in the kernel source tree) , and terminated it after
> > a few files were compiled and then again tried to compile my module,
> > this time it worked without any errors, ....... any particular reason
> > for this ??
> We are currently lacking a dependency on "scripts" so doing:
> make scripts
> make prepare
> is needed today.

As per makefile:
# make clean     Delete most generated files
#                Leave enough to build external modules

So is this OK to delete include/linux/bounds.h by 'make clean'.

--
JSR

