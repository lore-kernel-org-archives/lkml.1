Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbXFQV4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbXFQV4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760592AbXFQV4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:56:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:41064 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168AbXFQV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:56:16 -0400
Date: Sun, 17 Jun 2007 14:45:55 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] make pci_ids lowercase hexa
Message-ID: <20070617214555.GA305@kroah.com>
References: <116342983010020429@wsc.cz> <20070616195738.GB23443@kroah.com> <4674DDEF.8090600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4674DDEF.8090600@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 09:08:31AM +0200, Jiri Slaby wrote:
> Greg KH napsal(a):
> > On Sat, Jun 16, 2007 at 05:44:52PM +0200, Jiri Slaby wrote:
> >> make pci_ids lowercase hexa
> > 
> > Why?  What good is this going to do in the long run?
> 
> It's just cleanup to get rid of things like this:
>  #define PCI_DEVICE_ID_PROMISE_20246	0x4d33
>  #define PCI_DEVICE_ID_PROMISE_20262	0x4d38
> -#define PCI_DEVICE_ID_PROMISE_20263	0x0D38
> +#define PCI_DEVICE_ID_PROMISE_20263	0x0d38
>  #define PCI_DEVICE_ID_PROMISE_20268	0x4d68

Get rid of what?  What's wrong with upper case hex numbers?  This seems
like a pretty gratitous change to me.

> But still not necessary, if you think, it's useless -- but why don't
> have whole document formatted in one way. However this patch needs a
> -fix if ACKed due to bad regexp used (omitted '*' changes only the
> first uppercase letter found). If NACKed, this doesn't matter.
> 
> > Also, shouldn't you send pci specific patches like this to the pci
> > maintainer?  :)
> 
> Hell yes :/, every second time I post something, somebody is missing
> in the CC list, grr.

Care to resend your other fixes to me, if you still think they are
needed?

thanks,

greg k-h
