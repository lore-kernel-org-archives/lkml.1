Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbXIFWfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbXIFWfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbXIFWe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:34:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56098 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbXIFWe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:34:57 -0400
Date: Fri, 7 Sep 2007 00:36:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: kai@germaschewski.name, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] build system: section garbage collection for vmlinux
Message-ID: <20070906223617.GB10101@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051447.00774.vda.linux@googlemail.com> <20070905200750.GA30812@uranus.ravnborg.org> <200709061159.41133.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709061159.41133.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 11:59:41AM +0100, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 21:07, Sam Ravnborg wrote:
> > On Wed, Sep 05, 2007 at 02:47:00PM +0100, Denys Vlasenko wrote:
> > > On Wednesday 05 September 2007 14:43, Denys Vlasenko wrote:
> > > > These patches fix section names and add
> > > > CONFIG_DISCARD_UNUSED_SECTIONS. It is not enabled
> > > > unconditionally because only newest binutils have
> > > > ld --gc-sections which is stable enough for kernel use.
> > > > IOW: this is an experimental feature for now.
> > > 
> > > Part 1: fix section names over entire source (all arches).
> > > 
> > > Patch is big and boring global s/.text.lock/.text_lock/
> > > type thing.
> > 
> > The normal naming scheme seems to be:
> > .<usage>.text so in your example it would be: .lock.text
> > See the naming og init and exit sections (that was renamed
> > during 2.5 to be compatible with -ffunction-sections).
> 
> Thanks, will do it that way. I plan to re-submit patches for inclusion
> into 2.6.24.
This should simmer in -mm for a few weeks at minimum before hitting
mainline. I would cosider it 2.6.25 material.
We could use the 2.6.23 timeframe to bring up all the linker
script file to a level where adding all the KEEP's are mostly done
in the generic vmlinux.h file.

	Sam
