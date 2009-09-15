Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbZIOW5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbZIOW5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZIOW46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:56:58 -0400
Received: from kroah.org ([198.145.64.141]:42200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZIOW45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:56:57 -0400
Date: Tue, 15 Sep 2009 15:45:19 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, torvalds@linux-foundation.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB: console: fix kernel crash on stty -a < /dev/ttyUSB0
Message-ID: <20090915224519.GA24521@kroah.com>
References: <1252184918-9577-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252184918-9577-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 05, 2009 at 04:08:37PM -0500, Jason Wessel wrote:
> 
> * Boot with the kernel argument console=ttyUSB0,9600
> * Run: stty -a < /dev/ttyUSB0
> * Immediately you get an oops warning, which later leads to a hard
>   kernel crash

<snip>

I've had to drop this and your second patch due to conflicts with Alan
Stern's fixes.  Care to respin them on the next linux-next tree if they
are still needed?  I think Alan's fixes might have solved some of these
problems.

thanks,

greg k-h
