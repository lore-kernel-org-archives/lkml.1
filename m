Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0BKW6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:58:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:36515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab0BKW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:58:05 -0500
Date: Thu, 11 Feb 2010 14:54:52 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 2/2] Staging: hv: General maintenance of TODO file
Message-ID: <20100211225452.GA30820@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56212E881A9@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56212E88291@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213816.GB29557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56212E88346@TK5EX14MBXC118.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56212E88346@TK5EX14MBXC118.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:22:19PM +0000, Hank Janssen wrote:
> >> 
> >> Removed two line;
> >> 	Audit block driver
> >> 	Audit scsi driver
> >> They were added by us as part of the original code
> >> Submission to make sure these drivers kept on working
> >> Correctly with all the patches that came in from the 
> >> Community. 
> >
> >Um, no, those things still need to be done.
> 
> What additional things are expected? We solved the original 
> reason we added the lines

Um, I added the lines, see commit id
51b671f2f40c303fd4d18e346f63af62c9b1f622 for proof of that.

And as far as I can see, no such auditing has been done.

You need to pass the code by the proper subsystem maintainers (block and
scsi) before these items can be removed.

> , so I want to make sure we do additional work as is expected. We are
> going through general code cleanup, and the TODO file now. 
> 
> >> Added a new line to fix mostly insane camelcase naming
> >> We are working on that right now, but it will take a bit
> >> Due to the pervasive usage of it.
> >
> >That's fine, but it fits under the general "fix coding style issues".
> >
> >Hm, that isn't spelled out, but it is implicit, I doubt this really
> >needs to be documented in the file, it's just common knowledge :)
> 
> Want me to add a proper line item for that? Or drop this patch
> completely for the time being?

I say just drop it, you know you have to fix this :)

thanks,

greg k-h
