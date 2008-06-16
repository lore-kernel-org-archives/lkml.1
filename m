Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYFPXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYFPXjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbYFPXjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 19:39:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:47211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbYFPXjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 19:39:03 -0400
Date: Mon, 16 Jun 2008 16:37:30 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2/2] xen: don't drop NX bit
Message-ID: <20080616233730.GA25506@kroah.com>
References: <4856E2D4.3020402@goop.org> <20080616223508.GA1165@kroah.com> <4856EE79.1000205@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856EE79.1000205@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 03:51:37PM -0700, Jeremy Fitzhardinge wrote:
> Greg KH wrote:
>> While it's great that you tell the stable people about this, but is it
>> realistic?  Is anyone using Xen as contained in the mainline kernel
>> these days?
>>   
>
> Yes, it's what Redhat is shipping in Fedora 9.

Wow, great, I didn't realize this!  Nevermind then :)

>> If a distro were to be based on 2.6.25 and we take this patch, they will
>> just revert it back out due to their very large Xen patchset they apply
>> on top to get a "working" Xen version, right?
>>   
>
> No.  RH is using upstream Xen now.  I don't know what the other distros are 
> doing, but Novell is considering it, at least.

Heh, Novell isn't using it right now, look at the series of patches in
opensuse 11.0 for proof of that :(

Ok, no objection from me, when these hit Linus's tree we'll add them to
the -stable queue.

thanks,

greg k-h
