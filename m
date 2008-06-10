Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYFJTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYFJTjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYFJTjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:39:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43265 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbYFJTjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:39:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <484ED821.8020904@s5r6.in-berlin.de>
Date: Tue, 10 Jun 2008 21:38:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: chris2553@googlemail.com
CC: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
References: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org> <484D8019.3090900@s5r6.in-berlin.de> <200806101900.43572.chris2553@googlemail.com>
In-Reply-To: <200806101900.43572.chris2553@googlemail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Clayton wrote:
> I only 
> use firewire on the rare occasion that I want to grab some video from my camera 
> and I use the parallel port even less frequently. So one of the last things 
> that happens in my rc.local init script is that I unload the related drivers.

On an unrelated note:  If the driver was automatically loaded in a 
hotplug-like fashion (based on PCI IDs and module aliases), you could 
prevent it with "blacklist ohci1394" in one of the modprobe 
configuration files.
-- 
Stefan Richter
-=====-==--- -==- -=-=-
http://arcgraph.de/sr/
