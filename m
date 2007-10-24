Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXJXV4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXJXV4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXJXV4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:56:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40952 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbXJXV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:56:30 -0400
Date: Wed, 24 Oct 2007 14:25:35 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, vitalivanov@gmail.com, netwiz@crc.id.au
Subject: Re: USB: FIx locks and urb->status in adutux
Message-ID: <20071024212535.GA4638@kroah.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com> <200710231138.38266.oliver@neukum.org> <20071023185302.5ce9d187.zaitcev@redhat.com> <200710241649.13257.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710241649.13257.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:49:12PM +0200, Oliver Neukum wrote:
> Am Mittwoch 24 Oktober 2007 schrieb Pete Zaitcev:
> > Oliver, thanks for the inftdata catch. I also fixed the sleep_on.
> 
> But you are leaving a function while still on a waitqueue left on the stack.
> Here's a patch on top of yours.

Hm, I think I'll wait for Pete and you to agree and send me a final
version before applying anything here :)

thanks,

greg k-h
