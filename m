Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXJaSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXJaSp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbXJaSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 14:45:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:41231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbXJaSpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 14:45:19 -0400
Date: Wed, 31 Oct 2007 11:44:33 -0700
From: Greg KH <gregkh@suse.de>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Driver core: remove class_device_*_bin_file
Message-ID: <20071031184433.GA6654@suse.de>
References: <20071031050954.GA3791@kroah.com> <1193807505-3821-1-git-send-email-gregkh@suse.de> <12c511ca0710311026v39a91e61o448b340f413e08c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c511ca0710311026v39a91e61o448b340f413e08c0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 10:26:37AM -0700, Tony Luck wrote:
> On 10/30/07, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > These functions are not used by anyone, so remove them from the tree.
> 
> /me coughs ...
> 
>   CC      drivers/pci/probe.o
> drivers/pci/probe.c: In function `pci_create_legacy_files':
> drivers/pci/probe.c:57: error: implicit declaration of function
> `class_device_create_bin_file'
> drivers/pci/probe.c: In function `pci_remove_legacy_files':
> drivers/pci/probe.c:72: error: implicit declaration of function
> `class_device_remove_bin_file'

Oh crap, very sorry about this, I'll send a revert-patch to Linus in a
bit.

I didn't see this as I have patches in my tree that change these calls
to use struct device instead of struct class_device, but that's not
going to Linus until 2.6.25.

thanks,

greg k-h
