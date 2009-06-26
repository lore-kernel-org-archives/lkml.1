Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbZFZRbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbZFZRbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbZFZRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 13:31:06 -0400
Received: from smtp5.welho.com ([213.243.153.39]:34382 "EHLO smtp5.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbZFZRbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 13:31:05 -0400
Date: Fri, 26 Jun 2009 20:31:05 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>,
       Antonino Daplas <adaplas@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 18/19] drivers/video: Use PCI_VDEVICE
Message-ID: <20090626173105.GI9980@sci.fi>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Russell King <linux@arm.linux.org.uk>,
	Antonino Daplas <adaplas@gmail.com>,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Thomas Winischhofer <thomas@winischhofer.net>,
	linux-fbdev-devel@lists.sourceforge.net
References: <cover.1245906151.git.joe@perches.com> <198c226b3dfd003881e7f95b3fbbc8d433804b01.1245906153.git.joe@perches.com> <20090626095454.GH9980@sci.fi> <1246034126.18587.19.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246034126.18587.19.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:35:26AM -0700, Joe Perches wrote:
> On Fri, 2009-06-26 at 12:54 +0300, Ville Syrjälä wrote:
> > Perhaps there should be a PCI_VDDEVICE() or something for this type of
> > stuff? Would make things even shorter.
> 
> drivers/edac/edac_core.h has:
> 
> #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
> 	PCI_DEVICE_ID_ ## vend ## _ ## dev
> 
> Try submitting a patch and see what happens...

Too lazy. I was thinking that since you're already looking at
this stuff you might be tricked into doing some more work.

> > It seems your script missed atyfb. It could use PCI_VDEVICE() too.
> 
> Can you show an example please?

I didn't read you script and didn't look at the patches too closely. It
seems you only converted the open-coded stuff and not stuff already
using the PCI_DEVICE() macro. atyfb falls into this category.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
