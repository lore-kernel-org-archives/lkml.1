Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYKNSSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYKNSSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYKNSSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:18:34 -0500
Received: from kroah.org ([198.145.64.141]:40956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753856AbYKNSSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:18:34 -0500
Date: Fri, 14 Nov 2008 10:11:24 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 14 (staging)
Message-ID: <20081114181124.GA23441@kroah.com>
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au> <20081114095247.6b195091.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114095247.6b195091.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 09:52:47AM -0800, Randy Dunlap wrote:
> On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081113:
> > 
> > New tree:
> > 	staging
> 
> 
> drivers/staging/benet/mpu.c:146: error: implicit declaration of function 'udelay'
> 
> drivers/staging/comedi/proc.c:89: error: redefinition of 'comedi_proc_init'
> drivers/staging/comedi/comedidev.h:359: error: previous definition of 'comedi_proc_init' was here
> drivers/staging/comedi/proc.c:98: error: redefinition of 'comedi_proc_cleanup'
> drivers/staging/comedi/comedidev.h:362: error: previous definition of 'comedi_proc_cleanup' was here

Odd, I'm not getting these warnings here, can you give me a copy of your
.config?

thanks,

greg k-h
