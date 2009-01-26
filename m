Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZAZQIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZAZQIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZAZQIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:08:11 -0500
Received: from mx33.mail.ru ([194.67.23.194]:15903 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZAZQIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:08:09 -0500
X-Greylist: delayed 42862 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 11:08:08 EST
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andy Whitcroft <apw@canonical.com>
Subject: Re: checkpatch vs. checkpatch --file (was: Re: [Orinoco-devel] [PATCH] orinoco: checkpatch cleanup)
Date: Mon, 26 Jan 2009 19:06:48 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: Pavel Roskin <proski@gnu.org>, linux-kernel@vger.kernel.org
References: <200901252254.32137.arvidjaar@mail.ru> <200901260713.39734.arvidjaar@mail.ru> <20090126083830.GA17399@shadowen.org>
In-Reply-To: <20090126083830.GA17399@shadowen.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1763134.3JzF7cBPnp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901261907.25546.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1763134.3JzF7cBPnp
Content-Type: multipart/mixed;
  boundary="Boundary-01=_i+dfJU6DJ/8y64C"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_i+dfJU6DJ/8y64C
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 26 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 11:38:30 Andy Whitcroft wro=
te:
> On Mon, Jan 26, 2009 at 07:13:36AM +0300, Andrey Borzenkov wrote:
> > On 26 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 06:46:02 Pavel Roskin w=
rote:
> > > Please run the patch itself through checkpatch.  It finds two
> > > errors:
> > >
> > > ERROR: trailing statements should be on next line
> > > #163: FILE: drivers/net/wireless/orinoco/hermes.c:65:
> > > +                       printk(stuff); } while (0)
> > > +                       printk(stuff); } while (0)
> >
> > I ran "checkpatch --file hermes.c" after editing it and it found
> > zero errors.
> >
> > Cc checkpatch maintainer.
>
> Hmmm.  Could I have the patch and the file either before or after
> application please.
>

Sure. Here you have file after editing and patch between original and=20
file you get. File passes all checks, patch generates error:

{pts/2}% ~/src/linux-git/scripts/checkpatch.pl --file hermes.c
total: 0 errors, 0 warnings, 554 lines checked

hermes.c has no obvious style problems and is ready for submission.
{pts/2}% ~/src/linux-git/scripts/checkpatch.pl or/02-orinoco-cleanup-
hermes.c
ERROR: trailing statements should be on next line
#42: FILE: drivers/net/wireless/orinoco/hermes.c:65:
+                       printk(stuff); } while (0)
+                       printk(stuff); } while (0)
total: 1 errors, 0 warnings, 288 lines checked

or/02-orinoco-cleanup-hermes.c has style problems, please review.  If=20
any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


--Boundary-01=_i+dfJU6DJ/8y64C
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="hermes.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="hermes.c"

/* hermes.c
 *
 * Driver core for the "Hermes" wireless MAC controller, as used in
 * the Lucent Orinoco and Cabletron RoamAbout cards. It should also
 * work on the hfa3841 and hfa3842 MAC controller chips used in the
 * Prism II chipsets.
 *
 * This is not a complete driver, just low-level access routines for
 * the MAC controller itself.
 *
 * Based on the prism2 driver from Absolute Value Systems' linux-wlan
 * project, the Linux wvlan_cs driver, Lucent's HCF-Light
 * (wvlan_hcf.c) library, and the NetBSD wireless driver (in no
 * particular order).
 *
 * Copyright (C) 2000, David Gibson, Linuxcare Australia.
 * (C) Copyright David Gibson, IBM Corp. 2001-2003.
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License
 * at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and
 * limitations under the License.
 *
 * Alternatively, the contents of this file may be used under the
 * terms of the GNU General Public License version 2 (the "GPL"), in
 * which case the provisions of the GPL are applicable instead of the
 * above.  If you wish to allow the use of your version of this file
 * only under the terms of the GPL and not to allow others to use your
 * version of this file under the MPL, indicate your decision by
 * deleting the provisions above and replace them with the notice and
 * other provisions required by the GPL.  If you do not delete the
 * provisions above, a recipient may use your version of this file
 * under either the MPL or the GPL.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/delay.h>

#include "hermes.h"

MODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset"
		   " and Prism II HFA384x wireless MAC controller");
MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>"
	" & David Gibson <hermes@gibson.dropbear.id.au>");
MODULE_LICENSE("Dual MPL/GPL");

/* These are maximum timeouts. Most often, card wil react much faster */
#define CMD_BUSY_TIMEOUT (100) /* In iterations of ~1us */
#define CMD_INIT_TIMEOUT (50000) /* in iterations of ~10us */
#define CMD_COMPL_TIMEOUT (20000) /* in iterations of ~10us */
#define ALLOC_COMPL_TIMEOUT (1000) /* in iterations of ~10us */

/*
 * Debugging helpers
 */

#define DMSG(stuff...) do {printk(KERN_DEBUG "hermes @ %p: " , hw->iobase); \
			printk(stuff); } while (0)

#undef HERMES_DEBUG
#ifdef HERMES_DEBUG
#include <stdarg.h>

#define DEBUG(lvl, stuff...) if ((lvl) <= HERMES_DEBUG) DMSG(stuff)

#else /* ! HERMES_DEBUG */

#define DEBUG(lvl, stuff...) do { } while (0)

#endif /* ! HERMES_DEBUG */


/*
 * Internal functions
 */

/* Issue a command to the chip. Waiting for it to complete is the caller's
   problem.

   Returns -EBUSY if the command register is busy, 0 on success.

   Callable from any context.
*/
static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 param0,
			    u16 param1, u16 param2)
{
	int k = CMD_BUSY_TIMEOUT;
	u16 reg;

	/* First wait for the command register to unbusy */
	reg = hermes_read_regn(hw, CMD);
	while ((reg & HERMES_CMD_BUSY) && k) {
		k--;
		udelay(1);
		reg = hermes_read_regn(hw, CMD);
	}
	if (reg & HERMES_CMD_BUSY)
		return -EBUSY;

	hermes_write_regn(hw, PARAM2, param2);
	hermes_write_regn(hw, PARAM1, param1);
	hermes_write_regn(hw, PARAM0, param0);
	hermes_write_regn(hw, CMD, cmd);

	return 0;
}

/*
 * Function definitions
 */

/* For doing cmds that wipe the magic constant in SWSUPPORT0 */
int hermes_doicmd_wait(hermes_t *hw, u16 cmd,
		       u16 parm0, u16 parm1, u16 parm2,
		       struct hermes_response *resp)
{
	int err = 0;
	int k;
	u16 status, reg;

	err = hermes_issue_cmd(hw, cmd, parm0, parm1, parm2);
	if (err)
		return err;

	reg = hermes_read_regn(hw, EVSTAT);
	k = CMD_INIT_TIMEOUT;
	while ((!(reg & HERMES_EV_CMD)) && k) {
		k--;
		udelay(10);
		reg = hermes_read_regn(hw, EVSTAT);
	}

	hermes_write_regn(hw, SWSUPPORT0, HERMES_MAGIC);

	if (!hermes_present(hw)) {
		DEBUG(0, "hermes @ 0x%x: Card removed during reset.\n",
		       hw->iobase);
		err = -ENODEV;
		goto out;
	}

	if (!(reg & HERMES_EV_CMD)) {
		printk(KERN_ERR "hermes @ %p: "
		       "Timeout waiting for card to reset (reg=0x%04x)!\n",
		       hw->iobase, reg);
		err = -ETIMEDOUT;
		goto out;
	}

	status = hermes_read_regn(hw, STATUS);
	if (resp) {
		resp->status = status;
		resp->resp0 = hermes_read_regn(hw, RESP0);
		resp->resp1 = hermes_read_regn(hw, RESP1);
		resp->resp2 = hermes_read_regn(hw, RESP2);
	}

	hermes_write_regn(hw, EVACK, HERMES_EV_CMD);

	if (status & HERMES_STATUS_RESULT)
		err = -EIO;
out:
	return err;
}
EXPORT_SYMBOL(hermes_doicmd_wait);

void hermes_struct_init(hermes_t *hw, void __iomem *address, int reg_spacing)
{
	hw->iobase = address;
	hw->reg_spacing = reg_spacing;
	hw->inten = 0x0;
}
EXPORT_SYMBOL(hermes_struct_init);

int hermes_init(hermes_t *hw)
{
	u16 reg;
	int err = 0;
	int k;

	/* We don't want to be interrupted while resetting the chipset */
	hw->inten = 0x0;
	hermes_write_regn(hw, INTEN, 0);
	hermes_write_regn(hw, EVACK, 0xffff);

	/* Normally it's a "can't happen" for the command register to
	   be busy when we go to issue a command because we are
	   serializing all commands.  However we want to have some
	   chance of resetting the card even if it gets into a stupid
	   state, so we actually wait to see if the command register
	   will unbusy itself here. */
	k = CMD_BUSY_TIMEOUT;
	reg = hermes_read_regn(hw, CMD);
	while (k && (reg & HERMES_CMD_BUSY)) {
		if (reg == 0xffff) /* Special case - the card has probably been
				      removed, so don't wait for the timeout */
			return -ENODEV;

		k--;
		udelay(1);
		reg = hermes_read_regn(hw, CMD);
	}

	/* No need to explicitly handle the timeout - if we've timed
	   out hermes_issue_cmd() will probably return -EBUSY below */

	/* According to the documentation, EVSTAT may contain
	   obsolete event occurrence information.  We have to acknowledge
	   it by writing EVACK. */
	reg = hermes_read_regn(hw, EVSTAT);
	hermes_write_regn(hw, EVACK, reg);

	/* We don't use hermes_docmd_wait here, because the reset wipes
	   the magic constant in SWSUPPORT0 away, and it gets confused */
	err = hermes_doicmd_wait(hw, HERMES_CMD_INIT, 0, 0, 0, NULL);

	return err;
}
EXPORT_SYMBOL(hermes_init);

/* Issue a command to the chip, and (busy!) wait for it to
 * complete.
 *
 * Returns:
 *     < 0 on internal error
 *       0 on success
 *     > 0 on error returned by the firmware
 *
 * Callable from any context, but locking is your problem. */
int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
		      struct hermes_response *resp)
{
	int err;
	int k;
	u16 reg;
	u16 status;

	err = hermes_issue_cmd(hw, cmd, parm0, 0, 0);
	if (err) {
		if (!hermes_present(hw)) {
			if (net_ratelimit())
				printk(KERN_WARNING "hermes @ %p: "
				       "Card removed while issuing command "
				       "0x%04x.\n", hw->iobase, cmd);
			err = -ENODEV;
		} else
			if (net_ratelimit())
				printk(KERN_ERR "hermes @ %p: "
				       "Error %d issuing command 0x%04x.\n",
				       hw->iobase, err, cmd);
		goto out;
	}

	reg = hermes_read_regn(hw, EVSTAT);
	k = CMD_COMPL_TIMEOUT;
	while ((!(reg & HERMES_EV_CMD)) && k) {
		k--;
		udelay(10);
		reg = hermes_read_regn(hw, EVSTAT);
	}

	if (!hermes_present(hw)) {
		printk(KERN_WARNING "hermes @ %p: Card removed "
		       "while waiting for command 0x%04x completion.\n",
		       hw->iobase, cmd);
		err = -ENODEV;
		goto out;
	}

	if (!(reg & HERMES_EV_CMD)) {
		printk(KERN_ERR "hermes @ %p: Timeout waiting for "
		       "command 0x%04x completion.\n", hw->iobase, cmd);
		err = -ETIMEDOUT;
		goto out;
	}

	status = hermes_read_regn(hw, STATUS);
	if (resp) {
		resp->status = status;
		resp->resp0 = hermes_read_regn(hw, RESP0);
		resp->resp1 = hermes_read_regn(hw, RESP1);
		resp->resp2 = hermes_read_regn(hw, RESP2);
	}

	hermes_write_regn(hw, EVACK, HERMES_EV_CMD);

	if (status & HERMES_STATUS_RESULT)
		err = -EIO;

 out:
	return err;
}
EXPORT_SYMBOL(hermes_docmd_wait);

int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
{
	int err = 0;
	int k;
	u16 reg;

	if ((size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX))
		return -EINVAL;

	err = hermes_docmd_wait(hw, HERMES_CMD_ALLOC, size, NULL);
	if (err)
		return err;

	reg = hermes_read_regn(hw, EVSTAT);
	k = ALLOC_COMPL_TIMEOUT;
	while ((!(reg & HERMES_EV_ALLOC)) && k) {
		k--;
		udelay(10);
		reg = hermes_read_regn(hw, EVSTAT);
	}

	if (!hermes_present(hw)) {
		printk(KERN_WARNING "hermes @ %p: "
		       "Card removed waiting for frame allocation.\n",
		       hw->iobase);
		return -ENODEV;
	}

	if (!(reg & HERMES_EV_ALLOC)) {
		printk(KERN_ERR "hermes @ %p: "
		       "Timeout waiting for frame allocation\n",
		       hw->iobase);
		return -ETIMEDOUT;
	}

	*fid = hermes_read_regn(hw, ALLOCFID);
	hermes_write_regn(hw, EVACK, HERMES_EV_ALLOC);

	return 0;
}
EXPORT_SYMBOL(hermes_allocate);

/* Set up a BAP to read a particular chunk of data from card's internal buffer.
 *
 * Returns:
 *     < 0 on internal failure (errno)
 *       0 on success
 *     > 0 on error
 * from firmware
 *
 * Callable from any context */
static int hermes_bap_seek(hermes_t *hw, int bap, u16 id, u16 offset)
{
	int sreg = bap ? HERMES_SELECT1 : HERMES_SELECT0;
	int oreg = bap ? HERMES_OFFSET1 : HERMES_OFFSET0;
	int k;
	u16 reg;

	/* Paranoia.. */
	if ((offset > HERMES_BAP_OFFSET_MAX) || (offset % 2))
		return -EINVAL;

	k = HERMES_BAP_BUSY_TIMEOUT;
	reg = hermes_read_reg(hw, oreg);
	while ((reg & HERMES_OFFSET_BUSY) && k) {
		k--;
		udelay(1);
		reg = hermes_read_reg(hw, oreg);
	}

	if (reg & HERMES_OFFSET_BUSY)
		return -ETIMEDOUT;

	/* Now we actually set up the transfer */
	hermes_write_reg(hw, sreg, id);
	hermes_write_reg(hw, oreg, offset);

	/* Wait for the BAP to be ready */
	k = HERMES_BAP_BUSY_TIMEOUT;
	reg = hermes_read_reg(hw, oreg);
	while ((reg & (HERMES_OFFSET_BUSY | HERMES_OFFSET_ERR)) && k) {
		k--;
		udelay(1);
		reg = hermes_read_reg(hw, oreg);
	}

	if (reg != offset) {
		printk(KERN_ERR "hermes @ %p: BAP%d offset %s: "
		       "reg=0x%x id=0x%x offset=0x%x\n", hw->iobase, bap,
		       (reg & HERMES_OFFSET_BUSY) ? "timeout" : "error",
		       reg, id, offset);

		if (reg & HERMES_OFFSET_BUSY)
			return -ETIMEDOUT;

		return -EIO;		/* error or wrong offset */
	}

	return 0;
}

/* Read a block of data from the chip's buffer, via the
 * BAP. Synchronization/serialization is the caller's problem.  len
 * must be even.
 *
 * Returns:
 *     < 0 on internal failure (errno)
 *       0 on success
 *     > 0 on error from firmware
 */
int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
		     u16 id, u16 offset)
{
	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
	int err = 0;

	if ((len < 0) || (len % 2))
		return -EINVAL;

	err = hermes_bap_seek(hw, bap, id, offset);
	if (err)
		goto out;

	/* Actually do the transfer */
	hermes_read_words(hw, dreg, buf, len/2);

 out:
	return err;
}
EXPORT_SYMBOL(hermes_bap_pread);

/* Write a block of data to the chip's buffer, via the
 * BAP. Synchronization/serialization is the caller's problem.
 *
 * Returns:
 *     < 0 on internal failure (errno)
 *       0 on success
 *     > 0 on error from firmware
 */
int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
		      u16 id, u16 offset)
{
	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
	int err = 0;

	if (len < 0)
		return -EINVAL;

	err = hermes_bap_seek(hw, bap, id, offset);
	if (err)
		goto out;

	/* Actually do the transfer */
	hermes_write_bytes(hw, dreg, buf, len);

 out:
	return err;
}
EXPORT_SYMBOL(hermes_bap_pwrite);

/* Read a Length-Type-Value record from the card.
 *
 * If length is NULL, we ignore the length read from the card, and
 * read the entire buffer regardless. This is useful because some of
 * the configuration records appear to have incorrect lengths in
 * practice.
 *
 * Callable from user or bh context.  */
int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, unsigned bufsize,
		    u16 *length, void *buf)
{
	int err = 0;
	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
	u16 rlength, rtype;
	unsigned nwords;

	if ((bufsize < 0) || (bufsize % 2))
		return -EINVAL;

	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
	if (err)
		return err;

	err = hermes_bap_seek(hw, bap, rid, 0);
	if (err)
		return err;

	rlength = hermes_read_reg(hw, dreg);

	if (!rlength)
		return -ENODATA;

	rtype = hermes_read_reg(hw, dreg);

	if (length)
		*length = rlength;

	if (rtype != rid)
		printk(KERN_WARNING "hermes @ %p: %s(): "
		       "rid (0x%04x) does not match type (0x%04x)\n",
		       hw->iobase, __func__, rid, rtype);
	if (HERMES_RECLEN_TO_BYTES(rlength) > bufsize)
		printk(KERN_WARNING "hermes @ %p: "
		       "Truncating LTV record from %d to %d bytes. "
		       "(rid=0x%04x, len=0x%04x)\n", hw->iobase,
		       HERMES_RECLEN_TO_BYTES(rlength), bufsize, rid, rlength);

	nwords = min((unsigned)rlength - 1, bufsize / 2);
	hermes_read_words(hw, dreg, buf, nwords);

	return 0;
}
EXPORT_SYMBOL(hermes_read_ltv);

int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
		     u16 length, const void *value)
{
	int dreg = bap ? HERMES_DATA1 : HERMES_DATA0;
	int err = 0;
	unsigned count;

	if (length == 0)
		return -EINVAL;

	err = hermes_bap_seek(hw, bap, rid, 0);
	if (err)
		return err;

	hermes_write_reg(hw, dreg, length);
	hermes_write_reg(hw, dreg, rid);

	count = length - 1;

	hermes_write_bytes(hw, dreg, value, count << 1);

	err = hermes_docmd_wait(hw, HERMES_CMD_ACCESS | HERMES_CMD_WRITE,
				rid, NULL);

	return err;
}
EXPORT_SYMBOL(hermes_write_ltv);

static int __init init_hermes(void)
{
	return 0;
}

static void __exit exit_hermes(void)
{
}

module_init(init_hermes);
module_exit(exit_hermes);

--Boundary-01=_i+dfJU6DJ/8y64C
Content-Type: text/x-csrc;
  charset="us-ascii";
  name="02-orinoco-cleanup-hermes.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="02-orinoco-cleanup-hermes.c"

Subject: [PATCH] orinoco: checkpatch cleanup hermes.c
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

=46ix errors reported by checkpatch.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/net/wireless/orinoco/hermes.c |  102 ++++++++++++++++++-----------=
=2D---
 1 files changed, 56 insertions(+), 46 deletions(-)


diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/o=
rinoco/hermes.c
index bfa3753..f48358f 100644
=2D-- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -15,7 +15,7 @@
  *
  * Copyright (C) 2000, David Gibson, Linuxcare Australia.
  * (C) Copyright David Gibson, IBM Corp. 2001-2003.
=2D *=20
+ *
  * The contents of this file are subject to the Mozilla Public License
  * Version 1.1 (the "License"); you may not use this file except in
  * compliance with the License. You may obtain a copy of the License
@@ -45,7 +45,8 @@
=20
 #include "hermes.h"
=20
=2DMODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset an=
d Prism II HFA384x wireless MAC controller");
+MODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset"
+		   " and Prism II HFA384x wireless MAC controller");
 MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>"
 	" & David Gibson <hermes@gibson.dropbear.id.au>");
 MODULE_LICENSE("Dual MPL/GPL");
@@ -61,13 +62,13 @@ MODULE_LICENSE("Dual MPL/GPL");
  */
=20
 #define DMSG(stuff...) do {printk(KERN_DEBUG "hermes @ %p: " , hw->iobase)=
; \
=2D			printk(stuff);} while (0)
+			printk(stuff); } while (0)
=20
 #undef HERMES_DEBUG
 #ifdef HERMES_DEBUG
 #include <stdarg.h>
=20
=2D#define DEBUG(lvl, stuff...) if ( (lvl) <=3D HERMES_DEBUG) DMSG(stuff)
+#define DEBUG(lvl, stuff...) if ((lvl) <=3D HERMES_DEBUG) DMSG(stuff)
=20
 #else /* ! HERMES_DEBUG */
=20
@@ -95,20 +96,19 @@ static int hermes_issue_cmd(hermes_t *hw, u16 cmd, u16 =
param0,
=20
 	/* First wait for the command register to unbusy */
 	reg =3D hermes_read_regn(hw, CMD);
=2D	while ( (reg & HERMES_CMD_BUSY) && k ) {
+	while ((reg & HERMES_CMD_BUSY) && k) {
 		k--;
 		udelay(1);
 		reg =3D hermes_read_regn(hw, CMD);
 	}
=2D	if (reg & HERMES_CMD_BUSY) {
+	if (reg & HERMES_CMD_BUSY)
 		return -EBUSY;
=2D	}
=20
 	hermes_write_regn(hw, PARAM2, param2);
 	hermes_write_regn(hw, PARAM1, param1);
 	hermes_write_regn(hw, PARAM0, param0);
 	hermes_write_regn(hw, CMD, cmd);
=2D=09
+
 	return 0;
 }
=20
@@ -191,23 +191,23 @@ int hermes_init(hermes_t *hw)
 	hermes_write_regn(hw, EVACK, 0xffff);
=20
 	/* Normally it's a "can't happen" for the command register to
=2D           be busy when we go to issue a command because we are
=2D           serializing all commands.  However we want to have some
=2D           chance of resetting the card even if it gets into a stupid
=2D           state, so we actually wait to see if the command register
=2D           will unbusy itself here. */
+	   be busy when we go to issue a command because we are
+	   serializing all commands.  However we want to have some
+	   chance of resetting the card even if it gets into a stupid
+	   state, so we actually wait to see if the command register
+	   will unbusy itself here. */
 	k =3D CMD_BUSY_TIMEOUT;
 	reg =3D hermes_read_regn(hw, CMD);
 	while (k && (reg & HERMES_CMD_BUSY)) {
=2D		if (reg =3D=3D 0xffff) /* Special case - the card has probably been re=
moved,
=2D				      so don't wait for the timeout */
+		if (reg =3D=3D 0xffff) /* Special case - the card has probably been
+				      removed, so don't wait for the timeout */
 			return -ENODEV;
=20
 		k--;
 		udelay(1);
 		reg =3D hermes_read_regn(hw, CMD);
 	}
=2D=09
+
 	/* No need to explicitly handle the timeout - if we've timed
 	   out hermes_issue_cmd() will probably return -EBUSY below */
=20
@@ -228,7 +228,10 @@ EXPORT_SYMBOL(hermes_init);
 /* Issue a command to the chip, and (busy!) wait for it to
  * complete.
  *
=2D * Returns: < 0 on internal error, 0 on success, > 0 on error returned b=
y the firmware
+ * Returns:
+ *     < 0 on internal error
+ *       0 on success
+ *     > 0 on error returned by the firmware
  *
  * Callable from any context, but locking is your problem. */
 int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm0,
@@ -241,13 +244,13 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm=
0,
=20
 	err =3D hermes_issue_cmd(hw, cmd, parm0, 0, 0);
 	if (err) {
=2D		if (! hermes_present(hw)) {
+		if (!hermes_present(hw)) {
 			if (net_ratelimit())
 				printk(KERN_WARNING "hermes @ %p: "
 				       "Card removed while issuing command "
 				       "0x%04x.\n", hw->iobase, cmd);
 			err =3D -ENODEV;
=2D		} else=20
+		} else
 			if (net_ratelimit())
 				printk(KERN_ERR "hermes @ %p: "
 				       "Error %d issuing command 0x%04x.\n",
@@ -257,21 +260,21 @@ int hermes_docmd_wait(hermes_t *hw, u16 cmd, u16 parm=
0,
=20
 	reg =3D hermes_read_regn(hw, EVSTAT);
 	k =3D CMD_COMPL_TIMEOUT;
=2D	while ( (! (reg & HERMES_EV_CMD)) && k) {
+	while ((!(reg & HERMES_EV_CMD)) && k) {
 		k--;
 		udelay(10);
 		reg =3D hermes_read_regn(hw, EVSTAT);
 	}
=20
=2D	if (! hermes_present(hw)) {
+	if (!hermes_present(hw)) {
 		printk(KERN_WARNING "hermes @ %p: Card removed "
 		       "while waiting for command 0x%04x completion.\n",
 		       hw->iobase, cmd);
 		err =3D -ENODEV;
 		goto out;
 	}
=2D	=09
=2D	if (! (reg & HERMES_EV_CMD)) {
+
+	if (!(reg & HERMES_EV_CMD)) {
 		printk(KERN_ERR "hermes @ %p: Timeout waiting for "
 		       "command 0x%04x completion.\n", hw->iobase, cmd);
 		err =3D -ETIMEDOUT;
@@ -301,31 +304,30 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
 	int err =3D 0;
 	int k;
 	u16 reg;
=2D=09
=2D	if ( (size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX) )
+
+	if ((size < HERMES_ALLOC_LEN_MIN) || (size > HERMES_ALLOC_LEN_MAX))
 		return -EINVAL;
=20
 	err =3D hermes_docmd_wait(hw, HERMES_CMD_ALLOC, size, NULL);
=2D	if (err) {
+	if (err)
 		return err;
=2D	}
=20
 	reg =3D hermes_read_regn(hw, EVSTAT);
 	k =3D ALLOC_COMPL_TIMEOUT;
=2D	while ( (! (reg & HERMES_EV_ALLOC)) && k) {
+	while ((!(reg & HERMES_EV_ALLOC)) && k) {
 		k--;
 		udelay(10);
 		reg =3D hermes_read_regn(hw, EVSTAT);
 	}
=2D=09
=2D	if (! hermes_present(hw)) {
+
+	if (!hermes_present(hw)) {
 		printk(KERN_WARNING "hermes @ %p: "
 		       "Card removed waiting for frame allocation.\n",
 		       hw->iobase);
 		return -ENODEV;
 	}
=2D	=09
=2D	if (! (reg & HERMES_EV_ALLOC)) {
+
+	if (!(reg & HERMES_EV_ALLOC)) {
 		printk(KERN_ERR "hermes @ %p: "
 		       "Timeout waiting for frame allocation\n",
 		       hw->iobase);
@@ -334,14 +336,17 @@ int hermes_allocate(hermes_t *hw, u16 size, u16 *fid)
=20
 	*fid =3D hermes_read_regn(hw, ALLOCFID);
 	hermes_write_regn(hw, EVACK, HERMES_EV_ALLOC);
=2D=09
+
 	return 0;
 }
 EXPORT_SYMBOL(hermes_allocate);
=20
 /* Set up a BAP to read a particular chunk of data from card's internal bu=
ffer.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, >0 on error
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error
  * from firmware
  *
  * Callable from any context */
@@ -353,7 +358,7 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 i=
d, u16 offset)
 	u16 reg;
=20
 	/* Paranoia.. */
=2D	if ( (offset > HERMES_BAP_OFFSET_MAX) || (offset % 2) )
+	if ((offset > HERMES_BAP_OFFSET_MAX) || (offset % 2))
 		return -EINVAL;
=20
 	k =3D HERMES_BAP_BUSY_TIMEOUT;
@@ -374,7 +379,7 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 i=
d, u16 offset)
 	/* Wait for the BAP to be ready */
 	k =3D HERMES_BAP_BUSY_TIMEOUT;
 	reg =3D hermes_read_reg(hw, oreg);
=2D	while ( (reg & (HERMES_OFFSET_BUSY | HERMES_OFFSET_ERR)) && k) {
+	while ((reg & (HERMES_OFFSET_BUSY | HERMES_OFFSET_ERR)) && k) {
 		k--;
 		udelay(1);
 		reg =3D hermes_read_reg(hw, oreg);
@@ -386,9 +391,8 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 i=
d, u16 offset)
 		       (reg & HERMES_OFFSET_BUSY) ? "timeout" : "error",
 		       reg, id, offset);
=20
=2D		if (reg & HERMES_OFFSET_BUSY) {
+		if (reg & HERMES_OFFSET_BUSY)
 			return -ETIMEDOUT;
=2D		}
=20
 		return -EIO;		/* error or wrong offset */
 	}
@@ -400,7 +404,10 @@ static int hermes_bap_seek(hermes_t *hw, int bap, u16 =
id, u16 offset)
  * BAP. Synchronization/serialization is the caller's problem.  len
  * must be even.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, > 0 on error =
from firmware
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error from firmware
  */
 int hermes_bap_pread(hermes_t *hw, int bap, void *buf, int len,
 		     u16 id, u16 offset)
@@ -408,7 +415,7 @@ int hermes_bap_pread(hermes_t *hw, int bap, void *buf, =
int len,
 	int dreg =3D bap ? HERMES_DATA1 : HERMES_DATA0;
 	int err =3D 0;
=20
=2D	if ( (len < 0) || (len % 2) )
+	if ((len < 0) || (len % 2))
 		return -EINVAL;
=20
 	err =3D hermes_bap_seek(hw, bap, id, offset);
@@ -426,7 +433,10 @@ EXPORT_SYMBOL(hermes_bap_pread);
 /* Write a block of data to the chip's buffer, via the
  * BAP. Synchronization/serialization is the caller's problem.
  *
=2D * Returns: < 0 on internal failure (errno), 0 on success, > 0 on error =
from firmware
+ * Returns:
+ *     < 0 on internal failure (errno)
+ *       0 on success
+ *     > 0 on error from firmware
  */
 int hermes_bap_pwrite(hermes_t *hw, int bap, const void *buf, int len,
 		      u16 id, u16 offset)
@@ -440,11 +450,11 @@ int hermes_bap_pwrite(hermes_t *hw, int bap, const vo=
id *buf, int len,
 	err =3D hermes_bap_seek(hw, bap, id, offset);
 	if (err)
 		goto out;
=2D=09
+
 	/* Actually do the transfer */
 	hermes_write_bytes(hw, dreg, buf, len);
=20
=2D out:=09
+ out:
 	return err;
 }
 EXPORT_SYMBOL(hermes_bap_pwrite);
@@ -465,7 +475,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, uns=
igned bufsize,
 	u16 rlength, rtype;
 	unsigned nwords;
=20
=2D	if ( (bufsize < 0) || (bufsize % 2) )
+	if ((bufsize < 0) || (bufsize % 2))
 		return -EINVAL;
=20
 	err =3D hermes_docmd_wait(hw, HERMES_CMD_ACCESS, rid, NULL);
@@ -478,7 +488,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, uns=
igned bufsize,
=20
 	rlength =3D hermes_read_reg(hw, dreg);
=20
=2D	if (! rlength)
+	if (!rlength)
 		return -ENODATA;
=20
 	rtype =3D hermes_read_reg(hw, dreg);
@@ -503,7 +513,7 @@ int hermes_read_ltv(hermes_t *hw, int bap, u16 rid, uns=
igned bufsize,
 }
 EXPORT_SYMBOL(hermes_read_ltv);
=20
=2Dint hermes_write_ltv(hermes_t *hw, int bap, u16 rid,=20
+int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 		     u16 length, const void *value)
 {
 	int dreg =3D bap ? HERMES_DATA1 : HERMES_DATA0;

--Boundary-01=_i+dfJU6DJ/8y64C--

--nextPart1763134.3JzF7cBPnp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl936QACgkQR6LMutpd94zeUACfRxMC3hMxNgDW/ku5MHe6HO57
wAMAoNLeRY1D93KbIYZLEJQ0sPdIwL8I
=y228
-----END PGP SIGNATURE-----

--nextPart1763134.3JzF7cBPnp--
