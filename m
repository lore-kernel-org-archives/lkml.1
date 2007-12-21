Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbXLUWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbXLUWfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXLUWfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:35:46 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57375 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbXLUWfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:35:45 -0500
Date: Fri, 21 Dec 2007 14:34:38 -0800
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       jmorris@namei.org, alan@redhat.com, chrisw@redhat.com,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       solar@openwall.com, wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
Message-ID: <20071221223438.GB24780@kroah.com>
References: <1198101545.6197.52.camel@localhost.localdomain> <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr> <1198269079.3732.3.camel@localhost.localdomain> <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712212209240.11671@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 10:10:24PM +0100, Jan Engelhardt wrote:
> 
> On Dec 21 2007 15:31, Eric Paris wrote:
> >On Thu, 2007-12-20 at 00:29 +0100, Jan Engelhardt wrote:
> >> On Dec 19 2007 16:59, Eric Paris wrote:
> >> >
> >> >+config SECURITY_DEFAULT_MMAP_MIN_ADDR
> >> >+        int "Low address space to protect from user allocation"
> >> 
> >> Hm, should not this be 'hex'?
> >
> >I guess it could be, but the input for /proc/sys/vm/mmap_min_addr is
> >base 10 as well
> 
> sysfs is autobase, i.e. echo "0xb000" >/sys/foo will Do The Right Thing.

Hm, no, that is not sysfs doing this, and sysfs is not autobase in all
places.  That is sysctl (/proc/sys/), not sysfs.

thanks,

greg k-h
