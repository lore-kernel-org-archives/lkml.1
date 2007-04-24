Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXDXBVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXDXBVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbXDXBVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:21:10 -0400
Received: from lixom.net ([66.141.50.11]:48921 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbXDXBVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:21:09 -0400
Date: Mon, 23 Apr 2007 20:21:11 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Gerd Hoffmann <kraxel@suse.de>
Subject: Re: [PATCH 16/25] xen: Use the hvc console infrastructure for Xen console
Message-ID: <20070424012111.GA28649@lixom.net>
References: <20070423215638.563901986@goop.org> <20070423215712.328111104@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423215712.328111104@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 02:56:54PM -0700, Jeremy Fitzhardinge wrote:
> Implement a Xen back-end for hvc console.
> 
> From: Gerd Hoffmann <kraxel@suse.de>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> 
> ---
>  arch/i386/xen/Kconfig     |    1 
>  arch/i386/xen/events.c    |    3 -
>  drivers/Makefile          |    3 +
>  drivers/xen/Makefile      |    1 
>  drivers/xen/hvc-console.c |  134 +++++++++++++++++++++++++++++++++++++++++++++
>  include/xen/events.h      |    1 
>  6 files changed, 142 insertions(+), 1 deletion(-)

If you move the driver to drivers/char/hvc_xen.c instead, you won't have to do...

> +#include "../char/hvc_console.h"

...this.

Other single-platform backend hvc drivers are under drivers/char already.


-Olof
