Return-Path: <linux-kernel-owner+w=401wt.eu-S1752312AbYJVV2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbYJVV2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYJVV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:27:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYJVV1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:27:53 -0400
Date: Wed, 22 Oct 2008 14:24:17 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>, netdev <netdev@vger.kernel.org>,
       Dave Miller <davem@davemloft.net>, Al Viro <viro@ftp.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4][RFC] netns: sysfs: add a netns suffix to net
	device sysfs entries
Message-ID: <20081022212417.GA10265@suse.de>
References: <20081022152144.351965414@theryb.frec.bull.fr> <20081022201601.GC24959@suse.de> <m17i80l4mt.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17i80l4mt.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:08:26PM -0700, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Wed, Oct 22, 2008 at 05:21:44PM +0200, Benjamin Thery wrote:
> >> Network devices from sub-network namespaces appear in sysfs
> >> with a name that looks like this: device_name@netns_id
> >> eg: lo@3, eth0@4e
> >
> > How does the default udev rules as shipped by most distros handle the
> > renaming of the network device if the MAC address is duplicated like it
> > will be for these eth devices?
> 
> The mac address is not duplicated.

Ah, ok, I really don't think I want to know more :)

> Further devices like eth0@4e are completely unusable to the udev
> rules in the initial network namespace because they can not talk
> to or affect them.

Oh, good point.

> As I read it Ben's ``solution'' puts entries in sysfs that are
> completely unusable to udev.

That's not a good thing to do, if udev can't see them, than HAL can't
see them, then the rest of userspace usually has no idea they are
present either.

thanks,

greg k-h
