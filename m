Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbXGKVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbXGKVTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbXGKVTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:19:08 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36177
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751043AbXGKVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:19:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Start to genericize kconfig for use by other projects.
Date: Wed, 11 Jul 2007 17:18:57 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Roman Zippel <zippel@linux-m68k.org>
References: <200707111522.14240.rob@landley.net> <20070711195521.GO3492@stusta.de>
In-Reply-To: <20070711195521.GO3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111718.57652.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2007 3:55:21 pm Adrian Bunk wrote:
> On Wed, Jul 11, 2007 at 03:22:13PM -0400, Rob Landley wrote:
> >...
> > --- a/crypto/Makefile	Tue Jul 10 17:51:13 2007 -0700
> > +++ b/crypto/Makefile	Wed Jul 11 15:07:07 2007 -0400
> > @@ -50,3 +50,4 @@ obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
> >  obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
> >
> >  obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
> > +obj-m += randint.o
> >...

Oops.  Missed a revert.  Sorry 'bout that.

> If you'd have included a diffstat as described in
> Documentation/SubmittingPatches section 1 point 14 you might have
> noticed this yourself...

I was under the vague impression I'd read that, but going back I see that
diffstat is first mentioned on line 437 in the next to last paragraph
before "tips and tricks".  That's in paragraph 12 of point 14, and that's
counting the indented list elements as part of the proceeding paragraph.

Is there anything that could be done to make that document longer and more
rambling?  I see that last time I read it, I stopped during "Developers
Certificate of Origin 1.1", which is some kind of strange non-license license
which is more recent than the signed-off-by lines, but seems to be
retroactively stating that signed-off-by means you've read that thing...?  Is
that expected to hold up in court, is it just one of those random 1980's
shrinkware-license style intimidation tactics, is it some weird kind of
fraternity pledge...?

(/me goes to read up on diffstat...  Ah, I see, it's a program you install.  I
thought it was a diff option.  So possibly you could make SubmittingPatches
longer by mentioning that.)

With that file reverted, it's:

 scripts/kconfig/conf.c              |   26 ++++++++++++--------------
 scripts/kconfig/confdata.c          |    6 +++---
 scripts/kconfig/lkc.h               |    4 ++++
 scripts/kconfig/mconf.c             |   26 +++++++++++++-------------
 scripts/kconfig/zconf.tab.c_shipped |    2 +-
 scripts/kconfig/zconf.y             |    2 +-
 6 files changed, 34 insertions(+), 32 deletions(-)

> cu
> Adrian

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
