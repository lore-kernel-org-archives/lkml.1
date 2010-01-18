Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827Ab0ARSSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0ARSSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529Ab0ARSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:18:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0ARSSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:18:49 -0500
Date: Sun, 17 Jan 2010 17:35:21 -0800
From: Greg KH <gregkh@suse.de>
To: Emese Revfy <re.emese@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       teigland@redhat.com, Matt_Domsch@dell.com, maciej.sosnowski@intel.com,
       hjk@linutronix.de, Pekka Enberg <penberg@cs.helsinki.fi>,
       jens.axboe@oracle.com, shemminger@vyatta.com, akpm@linux-foundation.org,
       davem@davemloft.net, torvalds@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] Constify struct sysfs_ops for v2.6.33-rc4
Message-ID: <20100118013521.GA4190@suse.de>
References: <4B5338D6.2050209@gmail.com>
 <20100117182537.GQ19799@ZenIV.linux.org.uk>
 <4B536FF5.3000705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B536FF5.3000705@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 09:15:49PM +0100, Emese Revfy wrote:
> Al Viro wrote:
> > On Sun, Jan 17, 2010 at 05:20:38PM +0100, Emese Revfy wrote:
> > 
> >> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> >> Acked-by: David Teigland <teigland@redhat.com>
> >> Acked-by: Matt Domsch <Matt_Domsch@dell.com>
> >> Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> >> Acked-by: Hans J. Koch <hjk@linutronix.de>
> >> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> >> Acked-by: Stephen Hemminger <shemminger@vyatta.com>
> > 
> > NACKed-by: Al Viro <viro@zeniv.linux.org.uk>
> > 
> > Same reason.
> > 
> >> -        ssize_t (*show)(struct kobject *, struct attribute *, char *);
> >> -        ssize_t (*store)(struct kobject *, struct attribute *, const char *);
> >> +        ssize_t (* const show)(struct kobject *, struct attribute *, char *);
> >> +        ssize_t (* const store)(struct kobject *, struct attribute *, const char *);
> > 
> 
> Ok, I removed the field constification, here's the updated patch:

Please resend with proper changelog and other information so that it
could be applied.

thanks,

greg k-h
