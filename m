Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbXJDBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbXJDBqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXJDBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 21:46:09 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:57376
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968AbXJDBqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 21:46:07 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: + add-documentation-w1w1-masters-00-index.patch added to -mm tree
Date: Wed, 3 Oct 2007 20:46:03 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnpol@2ka.mipt.ru
References: <200710032117.l93LHXI0009109@imap1.linux-foundation.org> <20071003143849.46c7f157.randy.dunlap@oracle.com>
In-Reply-To: <20071003143849.46c7f157.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bXEBHGtyhtgMrMC"
Message-Id: <200710032046.03751.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_bXEBHGtyhtgMrMC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 03 October 2007 4:38:49 pm Randy Dunlap wrote:
> On Wed, 03 Oct 2007 14:17:33 -0700 akpm@linux-foundation.org wrote:
> > The patch titled
> >      Add Documentation/{w1,w1/masters}/00-INDEX
> > has been added to the -mm tree.  Its filename is
> >      add-documentation-w1w1-masters-00-index.patch
> >
> > *** Remember to use Documentation/SubmitChecklist when testing your code
> > ***
> >
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to
> > find out what to do about this
> >
> > ------------------------------------------------------
> > Subject: Add Documentation/{w1,w1/masters}/00-INDEX
> > From: Rob Landley <rob@landley.net>
> >
> > Two 00-INDEX files under Documentation/w1
> >
> > Signed-off-by: Rob Landley <rob@landley.net>
> > Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >
> > diff -puN /dev/null Documentation/w1/00-INDEX
> > --- /dev/null
> > +++ a/Documentation/w1/00-INDEX
> > @@ -0,0 +1,8 @@
> > +00-INDEX
> > +	- This file
> > +masters/
> > +	- Individual chips providing 1-wire busses.
> > +w1.generic
> > +	- The 1-wire (w1) bus
> > +w1.netlink
> > +	- Userspace communication protocol over connector [1].
> > diff -puN /dev/null Documentation/w1/masters/00-INDEX
> > --- /dev/null
> > +++ a/Documentation/w1/masters/00-INDEX
> > @@ -0,0 +1,6 @@
> > +00-INDEX
> > +	- This file
> > +ds2482
> > +	- The Maixm/Dallas Semiconductor DS2482 provides 1-wire busses.
> > +ds2490
> > +	- The Maixm/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.
>
>               Maxim (2 times)

That typo was cut and paste from the the "Description" section of both files.  
(Lines 18 and 13, respectively.)  :(

Attached is an updated version that spells it "maxim" and also fixes the typos 
in the source files, if that helps...

>
> Was this patch posted to a mailing list?  if so, which one?
> I didn't see it.

LKML on saturday.
http://lkml.org/lkml/2007/9/29/168

My pending patches are all at http://landley.net/kdocs/make/patches although 
I'm waiting for the current batch to work through before posting more.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_bXEBHGtyhtgMrMC
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="docw1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="docw1.patch"

From: Rob Landley <rob@landley.net>

Two 00-INDEX files under Documentation/w1 plus typo fixes.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/w1/masters/ds2482 |    2 +-
 Documentation/w1/masters/ds2490 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -r de183081194a Documentation/w1/masters/ds2482
--- a/Documentation/w1/masters/ds2482	Tue Oct 02 18:00:56 2007 +0000
+++ b/Documentation/w1/masters/ds2482	Wed Oct 03 20:28:05 2007 -0500
@@ -15,7 +15,7 @@ Description
 Description
 -----------
 
-The Maixm/Dallas Semiconductor DS2482 is a I2C device that provides
+The Maxim/Dallas Semiconductor DS2482 is a I2C device that provides
 one (DS2482-100) or eight (DS2482-800) 1-wire busses.
 
 
diff -r de183081194a Documentation/w1/masters/ds2490
--- a/Documentation/w1/masters/ds2490	Tue Oct 02 18:00:56 2007 +0000
+++ b/Documentation/w1/masters/ds2490	Wed Oct 03 20:28:05 2007 -0500
@@ -10,7 +10,7 @@ Description
 Description
 -----------
 
-The Maixm/Dallas Semiconductor DS2490 is a chip
+The Maxim/Dallas Semiconductor DS2490 is a chip
 which allows to build USB <-> W1 bridges.
 
 DS9490(R) is a USB <-> W1 bus master device
--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/w1/00-INDEX	2007-10-03 20:26:38.000000000 -0500
@@ -0,0 +1,8 @@
+00-INDEX
+	- This file
+masters/
+	- Individual chips providing 1-wire busses.
+w1.generic
+	- The 1-wire (w1) bus
+w1.netlink
+	- Userspace communication protocol over connector [1].
--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ hg/Documentation/w1/masters/00-INDEX	2007-10-03 20:26:55.000000000 -0500
@@ -0,0 +1,6 @@
+00-INDEX
+	- This file
+ds2482
+	- The Maxim/Dallas Semiconductor DS2482 provides 1-wire busses.
+ds2490
+	- The Maxim/Dallas Semiconductor DS2490 builds USB <-> W1 bridges.

--Boundary-00=_bXEBHGtyhtgMrMC--
