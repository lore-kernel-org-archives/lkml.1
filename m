Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIYFqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIYFqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 01:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYIYFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 01:46:08 -0400
Received: from eazy.amigager.de ([213.239.192.238]:55526 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYIYFqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 01:46:07 -0400
Date: Thu, 25 Sep 2008 07:47:09 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Differend udev names with different kernels
Message-ID: <20080925054708.GA18645@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-hotplug@vger.kernel.org
References: <20080924200127.GA2452@dose.home.local> <3ae72650809242012r7d144a64l35777f2a7bacbaa0@mail.gmail.com> <48DB1CC4.2040004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DB1CC4.2040004@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 07:08:20 +0200, Stefan Richter wrote:
> Kay Sievers wrote:
>> On Wed, Sep 24, 2008 at 13:01, Tino Keitel <tino.keitel@gmx.de> wrote:
>>> what's the intention of /dev/disk/by-id/?
>>>
>>> My firewire hard disk seems to have different names with different
>>> kernels.
>>>
>>> With 2.6.26.3, it's name is
>>> /dev/disk/by-id/ieee1394-0030e001e0006585:00043c:0000.
>>>
>>> With someting after 2.6.27-rc7, merged with Arjan's fastboot branch,
>>> the disk has the same name.
>
> Then this is a regression of the fastboot patch or whatever.

It has the same name with 2.6.26.3 and with 2.6.27-rc7-something with
fastboot merged. So why would this be a regression? The different name
(scsi-...) happended with a vanilla 2.6.27-rc7.

Initially, my intention was to find a unique name for the hard disk,
that stays even if the disk is changed from Firewire to USB. However,
this doesn't seem to be possible with a default udev.

Regards,
Tino
