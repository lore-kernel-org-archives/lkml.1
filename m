Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZLDRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZLDRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZLDRQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:16:55 -0500
Received: from mail.perches.com ([173.55.12.10]:1287 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbZLDRQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:16:54 -0500
Subject: [PATCH] MAINTAINERS: Add PowerPC patterns
From: Joe Perches <joe@perches.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <1259920775.2076.1273.camel@pasglop>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	 <1259894454.2076.1246.camel@pasglop>
	 <20091204103434.0a754925@hyperion.delvare>
	 <1259920775.2076.1273.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 09:16:59 -0800
Message-ID: <1259947019.22783.116.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 20:59 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2009-12-04 at 10:34 +0100, Jean Delvare wrote:
> > I've sent it to linuxppc-dev@ozlabs.org on October 14th. This is the
> > address which is listed 22 times in MAINTAINERS. If it isn't correct,
> > then please update MAINTAINERS.
> No it's fine both shoul work. Your patches are there, just waiting for
> me to pick them up, I was just firing a reminder to the rest of the CC
> list :-) (and I do remember fwd'ing a couple of your patches to the
> list, for some reason they didn't make it to patchwork back then, that
> was a few month ago).
> Anyways, I've been stretched thin with all sort of stuff lately, so bear
> with me if I'm a bit slow at taking or testing stuff, I'm doing my best.

Adding patterns to the PowerPC sections of MAINTAINERS is useful.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f96ac8..c7f8e5a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3193,6 +3193,7 @@ LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
 S:	Supported
+F:	arch/powerpc/boot/rs6000.h
 
 LINUX FOR POWERPC (32-BIT AND 64-BIT)
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
@@ -3201,18 +3202,24 @@ W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
 S:	Supported
+F:	Documentation/powerpc/
+F:	arch/powerpc/
 
 LINUX FOR POWER MACINTOSH
 M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/powermac/
+F:	drivers/macintosh/
 
 LINUX FOR POWERPC EMBEDDED MPC5XXX
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
+F:	arch/powerpc/platforms/512x/
+F:	arch/powerpc/platforms/52xx/
 
 LINUX FOR POWERPC EMBEDDED PPC4XX
 M:	Josh Boyer <jwboyer@linux.vnet.ibm.com>
@@ -3221,6 +3228,8 @@ W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc-4xx.git
 S:	Maintained
+F:	arch/powerpc/platforms/40x/
+F:	arch/powerpc/platforms/44x/
 
 LINUX FOR POWERPC EMBEDDED XILINX VIRTEX
 M:	Grant Likely <grant.likely@secretlab.ca>
@@ -3228,6 +3237,8 @@ W:	http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
 L:	linuxppc-dev@ozlabs.org
 T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
+F:	arch/powerpc/*/*virtex*
+F:	arch/powerpc/*/*/*virtex*
 
 LINUX FOR POWERPC EMBEDDED PPC8XX
 M:	Vitaly Bordug <vitb@kernel.crashing.org>
@@ -3241,12 +3252,16 @@ M:	Kumar Gala <galak@kernel.crashing.org>
 W:	http://www.penguinppc.org/
 L:	linuxppc-dev@ozlabs.org
 S:	Maintained
+F:	arch/powerpc/platforms/83xx/
 
 LINUX FOR POWERPC PA SEMI PWRFICIENT
 M:	Olof Johansson <olof@lixom.net>
 W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/platforms/pasemi/
+F:	drivers/*/*pasemi*
+F:	drivers/*/*/*pasemi*
 
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 M:	Chris Wright <chrisw@sous-sol.org>


