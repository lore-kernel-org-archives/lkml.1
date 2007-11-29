Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbXK2A7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbXK2A7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759455AbXK2A7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:59:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41090 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401AbXK2A7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:59:31 -0500
Date: Wed, 28 Nov 2007 16:58:41 -0800
From: Greg KH <greg@kroah.com>
To: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129005841.GA11860@kroah.com>
References: <200711281242.52941.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711281242.52941.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:42:52PM +0000, Tvrtko A. Ursulin wrote:
> 
> Hi Linus, all,
> 
> During one recent LKML discussion 
> (http://marc.info/?l=linux-kernel&m=119267398722085&w=2) about LSM going 
> static  you called for LSM users to speak up.
> 
> We here at Sophos (the fourth largest endpoint security vendor in the world) 
> have such a module called Talpa which is a part of our main endpoint security 
> product for Linux  that protects from viruses and malware hosted on Linux, 
> including those targetting Windows or other connected devices,  
> (http://www.sophos.com/products/enterprise/endpoint/security-and-control/linux/index.html) 
> which is GPL code and has been in the field for almost three years now. It's 
> source code has been shipping with the product from the start.  We also have 
> a SourceForge project at http://sourceforge.net/projects/talpa/ to host it.
> 
> In essence, what our module does is it intercepts file accesses and allows 
> userspace daemons to vet them. One of the means we implemented that is 
> through LSM and although it is not a perfect match for such use we prefer to 
> use an official interface. Unfortunately, with time it became impossible to 
> use LSM on some distributions (SELinux) so we had to implement other 
> intercept methods which are significantly less nice, and which may also 
> become unworkable over time.

Do you have a patch that shows the type of interface you would like to
see?  Like James stated, if you do not participate in the development
process, we have no way of knowing what you even want from the kernel.

What has kept you from submitting your code for inclusion in the main
kernel source tree?

Right now, your customers void their support warranties if they run your
software, as it can not be supported by the distros as an out-of-tree
kernel module.  I'm sure your customers would like to not have this
problem.

thanks,

greg k-h
