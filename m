Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0CFKli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 05:41:38 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:42438 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0CFKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 05:41:37 -0500
Date: Sat, 6 Mar 2010 11:41:31 +0100
From: Daniel Mack <daniel@caiaq.de>
To: dave b <db.pub.mail@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: weirdness with compiling a 2.6.33 kernel on arm debian
Message-ID: <20100306104131.GV28972@buzzloop.caiaq.de>
References: <25ae2d691003051958x72040b47g29d842f1d389a6cf@mail.gmail.com>
 <19346.6765.457769.167118@pilspetsen.it.uu.se>
 <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25ae2d691003060224x67ab1c9au5102c8a22518aff@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 09:24:49PM +1100, dave b wrote:
> On 6 March 2010 20:03, Mikael Pettersson <mikpe@it.uu.se> wrote:
> > dave b writes:
> >  > Hi have now successfully built a 2.6.33 kernel on a linkstation pro
> >  > v2. This is an arm device. It is currently running debianÂ  lenny
> >  > armel.
> >  >
> >  >
> >  > I compiledÂ  (make) zImage, then did a make modules which failed on the
> >  > first two rounds of compiling the modules -
> >  >
> >  > "fs/afs/super.c: In function â€˜afs_test_superâ€™:
> >  > fs/afs/super.c:278: internal compiler error: Segmentation fault
> >  > Please submit a full bug report,
> >  > with preprocessed source if appropriate.
> >  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions."
> >  > This was the error encountered on the attempt at compiling the
> >  > modules.
> >  >
> >  > "crypto/gcm.c: In function â€˜crypto_gcm_setauthsizeâ€™:
> >  > crypto/gcm.c:152: internal compiler error: Segmentation fault
> >  > Please submit a full bug report,
> >  > with preprocessed source if appropriate.
> >  > See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions.
> >  > make[1]: *** [crypto/gcm.o] Error 1"
> >  > This was the error the on the second attempt at compiling the modules.
> >  >
> >  > The 3rd attempt at building the modules was successful...

Whenever I had comparable problems, it was _always_ faulty RAM on my
local machine, and I'm very sure you're seeing a similar. _If_ gcc
crashes, it will always do that for the same input.

Daniel

