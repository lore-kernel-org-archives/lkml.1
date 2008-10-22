Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYJVUU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYJVUU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYJVUUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:20:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:40264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYJVUUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:20:08 -0400
Date: Wed, 22 Oct 2008 13:16:01 -0700
From: Greg KH <gregkh@suse.de>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: netdev <netdev@vger.kernel.org>, Dave Miller <davem@davemloft.net>,
       Eric Biederman <ebiederm@xmission.com>, Al Viro <viro@ftp.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4][RFC] netns: sysfs: add a netns suffix to net
	device sysfs entries
Message-ID: <20081022201601.GC24959@suse.de>
References: <20081022152144.351965414@theryb.frec.bull.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022152144.351965414@theryb.frec.bull.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 05:21:44PM +0200, Benjamin Thery wrote:
> Network devices from sub-network namespaces appear in sysfs
> with a name that looks like this: device_name@netns_id
> eg: lo@3, eth0@4e

How does the default udev rules as shipped by most distros handle the
renaming of the network device if the MAC address is duplicated like it
will be for these eth devices?

thanks,

greg k-h
