Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbZFZQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbZFZQfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbZFZQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:35:39 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3490 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZFZQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:35:38 -0400
Subject: Re: [PATCH 18/19] drivers/video: Use PCI_VDEVICE
From: Joe Perches <joe@perches.com>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>,
       Antonino Daplas <adaplas@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20090626095454.GH9980@sci.fi>
References: <cover.1245906151.git.joe@perches.com>
	 <198c226b3dfd003881e7f95b3fbbc8d433804b01.1245906153.git.joe@perches.com>
	 <20090626095454.GH9980@sci.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Jun 2009 09:35:26 -0700
Message-Id: <1246034126.18587.19.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 12:54 +0300, Ville Syrjälä wrote:
> Perhaps there should be a PCI_VDDEVICE() or something for this type of
> stuff? Would make things even shorter.

drivers/edac/edac_core.h has:

#define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
	PCI_DEVICE_ID_ ## vend ## _ ## dev

Try submitting a patch and see what happens...

> Also PCI_VDEVICE() does not use named initializers for some reason.
> Might be worth fixing.

Perhaps that's to avoid mixing named and unnamed initializers.

> It seems your script missed atyfb. It could use PCI_VDEVICE() too.

Can you show an example please?

