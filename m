Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbZCSSxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbZCSSxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbZCSSxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:53:18 -0400
Received: from kroah.org ([198.145.64.141]:51427 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755017AbZCSSxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:53:17 -0400
Date: Thu, 19 Mar 2009 11:51:40 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for March 19 (staging/psb)
Message-ID: <20090319185140.GB20608@kroah.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au> <49C27BBC.8070908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C27BBC.8070908@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:07:08AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090318:
> 
> 
> drivers/staging/psb/drm_os_linux.h:54: error: conflicting types for 'irqreturn_t'
> include/linux/irqreturn.h:14: error: previous declaration of 'irqreturn_t' was here

This one will be fixed tomorrow as I've pushed a new version of the
driver out that doesn't contain a new copy of the drm core.

> drivers/staging/psb/intel_reg.h:785:1: warning: "set_page_address" redefined
> include/linux/mm.h:622:1: warning: this is the location of the previous definition
> make[4]: *** [drivers/staging/psb/psb_drv.o] Error 1

Odd, I'll try to find this one.

thanks,

greg k-h
