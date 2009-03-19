Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZCSImR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZCSImR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 04:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCSImB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 04:42:01 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50879
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZCSIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 04:41:59 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Date: Thu, 19 Mar 2009 03:41:53 -0500
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: Greg Ungerer <gerg@snapgear.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org, linux-m68k@vger.kernel.org
References: <200903120437.03837.rob@landley.net> <200903181312.02047.rob@landley.net> <10f740e80903190059qae0629bs8658cad8f3ad8761@mail.gmail.com>
In-Reply-To: <10f740e80903190059qae0629bs8658cad8f3ad8761@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903190341.54222.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 02:59:45 Geert Uytterhoeven wrote:
> On Wed, Mar 18, 2009 at 19:12, Rob Landley <rob@landley.net> wrote:
> > On Wednesday 18 March 2009 00:34:43 Greg Ungerer wrote:
> >> Rob Landley wrote:
> >> > On Monday 16 March 2009 18:10:45 Greg Ungerer wrote:
> >> >>>>    git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
> >> >>>> fix-includes
> >
> > ...
> >
> >> > What _should_ I have done?
> >>
> >> The git clone you have done will just get the master branch,
> >> and put it in a directory named fix-includes.
> >>
> >> Which is ok, but you still won't have the "fix-includes" branch.
> >> Do this after the clone:
> >>
> >>    git pull
> >> git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
> >> fix-includes
> >
> > Ah, that did something interesting...  And the resulting headers built in
> > uClibc.  (Works for me!)
> >
> > confirmed-uClibc-builds-with-it-by: Rob Landley <rob@landley.net>
>
> Does it boot on ARAnyM? ;-)

Dunno.  When I ran aranym it popped up a menu screen and asked me to configure 
it, so I tracked down a couple of howtos I haven't had time to read yet 
(http://wiki.aranym.org/aranym_from_scratch and 
http://wiki.aranym.org/afs/setup_linux).

At a glance the emulator doesn't seem to actually support a serial port, so no 
serial console, which is a bit of a limiting factor for how I normally use 
it...

Rob
