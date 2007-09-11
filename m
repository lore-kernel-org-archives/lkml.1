Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbXIKQuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbXIKQuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXIKQty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:49:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41258 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbXIKQtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:49:53 -0400
Date: Tue, 11 Sep 2007 18:51:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>, bwalle@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: build #286 failed for 2.6.23-rc6-g0d4cbb5 in linux/arch/i386/mach-voyager/setup.c
Message-ID: <20070911165117.GA6637@uranus.ravnborg.org>
References: <200709111621.39060.toralf.foerster@gmx.de> <1189521015.5351.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1189521015.5351.11.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 09:30:15AM -0500, James Bottomley wrote:
> On Tue, 2007-09-11 at 16:21 +0200, Toralf Förster wrote:
> > Hello,
> > 
> > the build with the attached .config failed, make ends with:
> > ...
> >   CC      arch/i386/mm/highmem.o
> >   LD      arch/i386/mm/built-in.o
> >   CC      arch/i386/mach-voyager/setup.o
> > arch/i386/mach-voyager/setup.c: In function 'time_init_hook':
> > arch/i386/mach-voyager/setup.c:52: error: implicit declaration of function 'safe_smp_processor_id'
> 
> This should be a warning, not an error

Nope. On purpose we use:
-Werror-implicit-function-declaration

The purpose being that otherwise this is not fixed.

	Sam
