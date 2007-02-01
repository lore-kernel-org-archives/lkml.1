Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXBAEa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXBAEa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161167AbXBAEa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:30:28 -0500
Received: from ns2.suse.de ([195.135.220.15]:40569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXBAEa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:30:27 -0500
Date: Wed, 31 Jan 2007 20:29:09 -0800
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Garzik <jeff@garzik.org>,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
Message-ID: <20070201042909.GD3648@kroah.com>
References: <1169714047.65693.647693675533.qpush@cradle> <m1hcubq6re.fsf@ebiederm.dsl.xmission.com> <1170015805.26655.15.camel@localhost.localdomain> <45BD0BDC.40205@garzik.org> <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com> <1170022154.26655.63.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170022154.26655.63.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 09:09:14AM +1100, Benjamin Herrenschmidt wrote:
> 
> If we followed that "only do incrementental changes" rule all the time,
> imagine in what state would be our USB stack today since we couldn't
> have dropped in Linus replacement one ...

Bad example, that is not what happened at all.  There was not an
in-kernel USB stack when Linus wrote his.  Inaky had his
all-singing-all-dancing stack outside of the tree, and no one was really
helping out with it.

Only when Linus added his code to mainline did we all jump on it and
_incrementally_ improve it to what we have today.

So, in a way, you just proved that we need to do this in an incremental
fashion, which is what I was also saying all along :)

thanks,

greg k-h
