Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYCZP5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYCZP5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYCZP5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:57:45 -0400
Received: from iksaif.dns26.com ([84.246.226.15]:34510 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYCZP5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:57:44 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2008 11:57:44 EDT
From: Corentin CHARY <corentincj@iksaif.net>
Reply-To: corentincj@iksaif.net
To: Len Brown <lenb@kernel.org>
Subject: Re: ISA -> ISA_ (Re: [GIT PATCH] ACPI patches for 2.6.25-rc6)
Date: Wed, 26 Mar 2008 16:45:00 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200803180510.47670.lenb@kernel.org> <20080326081653.GA8247@elte.hu> <200803261132.21448.lenb@kernel.org>
In-Reply-To: <200803261132.21448.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803261645.01343.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008 16:32:20 Len Brown wrote:
> So if this is correct or not depends on what the BIOS programmer
> for the Asus A1x choose to write.  Perhaps Corentin 'Iksaif' CHARY
> can confirm if the driver is working properly on that system.

Hi,
Sorry I don't have an A1x to test that, and this was here a long time before I start working on acpi4asus.
But, see that grep :

chary_c@foo /usr/src/linux/drivers/misc $ grep ISA *
asus-laptop.c:      "\\_SB.PCI0.ISA.EC0._Q10",  /* A1x */
thinkpad_acpi.c:IBM_HANDLE(ec, root, "\\_SB.PCI0.ISA.EC0",      /* 240, 240x */
thinkpad_acpi.c:           "\\_SB.PCI.ISA.EC",  /* 570 */
thinkpad_acpi.c:           "\\_SB.PCI0.ISA0.EC0",       /* 600e/x, 770e, 770x */
thinkpad_acpi.c:           "\\_SB.PCI0.ISA.EC", /* A21e, A2xm/p, T20-22, X20-21 */
thinkpad_acpi.c:           "\\_SB.PCI.ISA.SLCE",        /* 570 */

So it seems to work for thinkpads.
I think this patch isn't needed.

-- 
Corentin 'Iksaif' CHARY
http://xf.iksaif.net
