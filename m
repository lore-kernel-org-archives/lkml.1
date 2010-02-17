Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0BRAQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:16:54 -0500
Received: from kroah.org ([198.145.64.141]:49914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab0BRAQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:16:19 -0500
Date: Wed, 17 Feb 2010 15:50:21 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Hank Janssen <hjanssen@microsoft.com>,
       "'gregkh@suse.de'" <gregkh@suse.de>
Subject: Re: [PATCH 1/1] Stage: hv: Rename struct device_context and
 re-arrange the fields inside (re-formatted)
Message-ID: <20100217235020.GF12197@kroah.com>
References: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF725A908A11@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 08:58:47PM +0000, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Rename struct device_context and re-arrange the fields inside.
> Rename struct device_context to struct vm_device, and move 
> struct device field to the end according to Document/driver-model standard.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

What tree did you make this against?  I'm getting conflicts in the
drivers/staging/hv/storvsc_drv.c file.  Let me go see if they are
trivial for me to fix up or not...

thanks,

greg k-h
