Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZGTUA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZGTUA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZGTUA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:00:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZGTUA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:00:57 -0400
Date: Mon, 20 Jul 2009 12:57:54 -0700
From: Greg KH <gregkh@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720195754.GB30483@suse.de>
References: <20090720160025.GA20249@kroah.com>
 <20090720162810.GA22102@kroah.com>
 <20090720165941.GA15660@redhat.com>
 <20090720170345.GA23990@suse.de>
 <871vob4047.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871vob4047.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:37:12PM +0200, Andi Kleen wrote:
> Greg KH <gregkh@suse.de> writes:
> >
> > It's the "normal" way of cleaning up code.  Start with a known-working
> > piece of stuff, and incrementally clean it up. 
> 
> I have to agree with David. This is essentially unreviewable
> in the original state. It would be good if you could
> do all the obvious cleanups first and then post a consolidated
> series.
> 
> Most "obvious" cleanups should not change the binary, so
> you can easily check they are correct by comparing the assembler
> code.

Unfortunatly, some of these cleanups do change the binary, as they are
removing wrapper functions.

Anyway, I agree, for a "proper" review, I will show the final, cleaned
up version, like normal.  But we aren't there just yet, that is why this
code is going to live in the staging tree for a while.  Give us some
time to get it fixed up.

thanks,

greg k-h
