Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0BQVKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:10:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab0BQVKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:10:40 -0500
Date: Wed, 17 Feb 2010 13:05:56 -0800
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] Stage: hv: Rename struct device_context and
 re-arrange the fields inside (re-formatted)
Message-ID: <20100217210556.GA17038@suse.de>
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

There is no need to move the struct device to the end, it can be
anywhere in the structure, just don't put it at the beginning so you
think you can cast pointers like other parts of the hv code does.

Anyway, no big deal, I'll queue this up in a bit.

thanks,

greg k-h
