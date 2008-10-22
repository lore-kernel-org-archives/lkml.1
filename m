Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYJVFER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYJVFER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 01:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYJVFEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 01:04:01 -0400
Received: from kroah.org ([198.145.64.141]:42960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044AbYJVFEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 01:04:00 -0400
Date: Tue, 21 Oct 2008 22:01:42 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 21 (printk format warnings)
Message-ID: <20081022050142.GA11674@kroah.com>
References: <20081021195109.ed83b102.sfr@canb.auug.org.au> <20081021215725.b9c2b941.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021215725.b9c2b941.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:57:25PM -0700, Randy Dunlap wrote:
> On Tue, 21 Oct 2008 19:51:09 +1100 Stephen Rothwell wrote:
> 
> 
> printk format warnings summary:
> 
> i386:
> 
> linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
> 
> linux-next-20081021/drivers/misc/intel_menlow.c:107: warning: format '%ld' expects type 'long int', but argument 3 has type 'long long unsigned int'
> 
> x86_64:
> 
> linux-next-20081021/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format '%08lx' expects type 'long unsigned int', but argument 3 has type 'long long unsigned int'
> 
> linux-next-20081021/drivers/usb/misc/vstusb.c:623: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Crap.  What's the expected modifier for "size_t" to work on all arches?

Same goes for the result of "size_of()", what should we use there?  Or
are we just required to always cast things?

thanks,

greg k-h
