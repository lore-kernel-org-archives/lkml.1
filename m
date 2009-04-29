Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZD2EPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZD2EPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZD2EPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:15:30 -0400
Received: from kroah.org ([198.145.64.141]:34911 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbZD2EP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:15:29 -0400
Date: Tue, 28 Apr 2009 21:10:56 -0700
From: Greg KH <greg@kroah.com>
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: netlink NETLINK_KOBJECT_UEVENT older 2.6 kernels
Message-ID: <20090429041056.GJ23062@kroah.com>
References: <254340.43645.qm@web32405.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254340.43645.qm@web32405.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:32:07PM -0700, Anil kumar wrote:
> 
> Hi,
> 
> I see that we can use NETLINK_KOBJECT_UEVENT to send kernel messages
> to user space. This is available in most of the latest 2.6 kernels.
> But if I pick older kernels like 2.6.9 and NETLINK_KOBJECT_UEVENT is
> not available.
> 
> Is there anything equivalent to NETLINK_KOBJECT_UEVENT for the driver
> to send messages to user space in older 2.6 kernels?

Older like 2.6.9?  Wow, that's _many_ years old, why do you want to add
support for old kernels to something you are developing now?

Older kernels used the /sbin/hotplug interface to send messages to
userspace, you can use that.

good luck, you will need it :)

greg k-h
