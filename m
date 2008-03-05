Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbYCEQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbYCEQIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759764AbYCEQH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:07:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:47749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761185AbYCEQH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:07:56 -0500
Date: Wed, 5 Mar 2008 08:05:55 -0800
From: Greg KH <gregkh@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/8] driver core: fix up Kconfig text for
	CONFIG_SYSFS_DEPRECATED
Message-ID: <20080305160555.GA31159@suse.de>
References: <20080304231519.GC3073@suse.de> <1204672732-3127-1-git-send-email-gregkh@suse.de> <18322.1204732693@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18322.1204732693@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 10:58:13AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 04 Mar 2008 15:18:45 PST, Greg Kroah-Hartman said:
> 
> > -	  If you are using a distro that was released in 2006 or later,
> > -	  it should be safe to say N here.
> > +	  If you are using a distro with the most recent userspace
> > +	  packages, it should be safe to say N here.
> 
> Might want to be a bit more specific here - I *think* udev, lvm, and nash
> were the common ones that broke this time around.

udev did not break, and nash is a shell, so it would have a hard time
"breaking" :)

> Speaking of which, did anybody rev Documentation/Changes to mention
> the currently required releases of stuff?

The versions "required" did not change if you just enable that config
option.

thanks,

greg k-h
