Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYGJAge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYGJAge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYGJAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:36:26 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:38323 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYGJAgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:36:25 -0400
Subject: Re: [tpmdd-devel] Patch for Broadcom TPM TIS device HID
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: eledisez <eledisez@grounation.org>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <379cac7442a57a702f75cb2194dee9eb@localhost>
References: <2d97a3960807050312w76bde4c7hadeebb8a36aae761@mail.gmail.com>
	 <1215640191.25273.45.camel@blackbox>
	 <379cac7442a57a702f75cb2194dee9eb@localhost>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 21:34:23 -0300
Message-Id: <1215650063.25273.77.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This depends on patch posted with "[PATCH] tpm: add Intel TPM TIS device HID" subject.

From: LE DISEZ Erwan <eledisez@grounation.org>
Subject: add Broadcom TPM TIS device HID

	Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm_tis.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index c7a977b..ed1879c 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -622,6 +622,7 @@ static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"ATM1200", 0},		/* Atmel */
 	{"IFX0102", 0},		/* Infineon */
 	{"BCM0101", 0},		/* Broadcom */
+	{"BCM0102", 0},		/* Broadcom */
 	{"NSC1200", 0},		/* National */
 	{"ICO0102", 0},		/* Intel */
 	/* Add new here */
-- 

On Thu, 2008-07-10 at 01:03 +0200, eledisez wrote:
> Hi,
> 
> all right, for the next time.
> 
> Thanks.
> Erwan.
> 
> On Wed, 09 Jul 2008 18:49:51 -0300, Rajiv Andrade
> <srajiv@linux.vnet.ibm.com> wrote:
> > Please add the Signed-off-by and whenever possible submit the patch in
> > `patch -p1' form.
> > 
> > Thanks,
> > Rajiv
> > 
> > On Sat, 2008-07-05 at 12:12 +0200, Erwan LE DISEZ wrote:
> >> This patch adds Broadcom TPM TIS device HID : BCM0102.
> >> 
> >> Tested with by DELL D630 Laptop computer.
> >> Best regards. LE DISEZ Erwan.
> >>
> > -------------------------------------------------------------------------
> >> Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
> >> Studies have shown that voting for your favorite open source project,
> >> along with a healthy diet, reduces your potential for chronic lameness
> >> and boredom. Vote Now at http://www.sourceforge.net/community/cca08
> >> _______________________________________________ tpmdd-devel mailing list
> > tpmdd-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

