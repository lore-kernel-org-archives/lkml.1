Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZAWFXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZAWFXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZAWFXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:23:40 -0500
Received: from mx1.suse.de ([195.135.220.2]:53006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZAWFXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:23:39 -0500
Date: Thu, 22 Jan 2009 21:16:20 -0800
From: Greg KH <gregkh@suse.de>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090123051620.GA8122@suse.de>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232686261.9977.1296303473@webmail.messagingengine.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 03:51:01PM +1100, Bron Gondwana wrote:
> On Wed, 03 Dec 2008 11:48 -0800, "Greg KH" <gregkh@suse.de> wrote:
> > The default value for "max_user_instances" is set to 128, that should be enough too.
> 
> Our fairly heavily loaded postfix backup mx (lots of spams rejected per day) hit this
> limit running kernel 2.6.27.8.  Any particular reason for it being as low as 128
> by default?

Something had to be picked :)

> This is a kvm virtual machine running on a reasonably beefy external box, but
> with 2Gb RAM allocated to the mx instance because that's all kvm would let me
> use last time I checked.  We're using KVM so the local copy of the database is
> a little further away from the "internet facing side" and so we can build each
> machine with our standard FAI setup.

I would suggest just changing this default value then, it's a simple
userspace configuration item, and for your boxes, it sounds like a
larger value would be more suitable.

thanks,

greg k-h
