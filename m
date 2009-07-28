Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZG1VFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZG1VFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbZG1VFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:05:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbZG1VFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:05:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [Bug #13643] Touchpad lost synchronization after resume from suspend to RAM
Date: Tue, 28 Jul 2009 23:05:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <20090727225946.048A3526EC9@mailhub.coreip.homeip.net> <20090728000945.GA13815@vespa.holoscopio.com>
In-Reply-To: <20090728000945.GA13815@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907282305.29552.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 July 2009, Thadeu Lima de Souza Cascardo wrote:
> On Mon, Jul 27, 2009 at 03:25:51PM -0700, Dmitry Torokhov wrote:
> > On Tue, Jul 28, 2009 at 12:15:54AM +0200, Rafael J. Wysocki wrote:
> > > On Monday 27 July 2009, Thadeu Lima de Souza Cascardo wrote:
> > > > On Sun, Jul 26, 2009 at 10:23:34PM +0200, Rafael J. Wysocki wrote:
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > > > (either way).
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13643
> > > > > Subject		: Touchpad lost synchronization after resume from suspend to RAM
> > > > > Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
> > > > > Date		: 2009-06-28 10:42 (29 days old)
> > > > > References	: http://lkml.org/lkml/2009/6/23/365
> > > > > 		  2.6.30-rc1: touchpad disabled
> > > > > 		  http://lkml.org/lkml/2009/6/25/256
> > > > > Handled-By	: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> > > > > Patch		: http://patchwork.kernel.org/patch/34075/
> > > > > 
> > > > > 
> > > > 
> > > > I guess my patch did fix it and we had other confirmations as well,
> > > > didn't we?
> > > 
> > > Yes, we did.  It's waiting in the Dmirty's tree for Linus to take it AFAICS.
> > > 
> > 
> > I believe it is in -rc4 actually.
> > 
> > -- 
> > Dmitry
> 
> It entered in v2.6.31-rc3. Thanks, Dimitry.
> 
> cascardo@vespa:~/linux$ git log1 --author=cascardo v2.6.31-rc2..v2.6.31-rc3
> ddaa43433dd77535e4e132787f199f58ce224f44 Input: mark serio and i8042 as suspende
> cascardo@vespa:~/linux$

Thanks, closed.

Rafael
