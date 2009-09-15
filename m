Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZIOOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZIOOJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZIOOJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:09:42 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:60776 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbZIOOJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:09:41 -0400
Message-ID: <4AAFA025.3050401@codemonkey.ws>
Date: Tue, 15 Sep 2009 09:09:41 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Amit Shah <amit.shah@redhat.com>, Alan Cox <alan@linux.intel.com>,
       rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic
 guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <1252678386-17404-2-git-send-email-amit.shah@redhat.com> <20090911170010.34c80f2d@linux.intel.com> <20090915123752.GB5247@amit-x200.redhat.com> <4AAF8F26.8030503@codemonkey.ws> <4AAF9FD8.1010008@redhat.com>
In-Reply-To: <4AAF9FD8.1010008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>> Userspace can detect when new virtio-consoles appear via udev events.
>> When it sees a new ttyVN, it can then look in sysfs to discover it's 
>> name.
>
> No.  udev can create symlinks for you, so apps don't have to dig into 
> sysfs.  You'll need a rule along the lines (untested):
>
>    SUBSYSTEM=="virtio", \
>    DRIVERS="virtio-console", \
>    SYMLINK+="vcon/$attr{name}"
>
> then udev will create a /dev/vcon/org.qemu.clipboard symlink pointing 
> to dev/ttyV0.  Apps can just open /dev/vcon/$name then.

That works equally well.  I don't necessarily think that naming is more 
useful.

Regards,

Anthony Liguori
