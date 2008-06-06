Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbYFFXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbYFFXd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYFFXdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 19:33:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40586 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbYFFXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 19:33:14 -0400
Date: Fri, 6 Jun 2008 16:30:37 -0700
From: Greg KH <greg@kroah.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-ID: <20080606233037.GA8548@kroah.com>
References: <200806061922.m56JMJuq025990@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806061922.m56JMJuq025990@hera.kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 07:22:25PM +0000, Linux Kernel Mailing List wrote:
> @@ -1920,23 +2004,16 @@ sub process {
>  				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
>  			}
>  		}
> -# check for needless usb_free_urb() checks
> -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> -			my $expr = $1;
> -			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
> -				WARN("usb_free_urb(NULL) is safe this check is probabally not required\n" . $hereprev);
> -			}
> -		}
>  

I'm curious as to why this check was removed.  Any specific reason?  It
was valid from what I can tell.

thanks,

greg k-h
