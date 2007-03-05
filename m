Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXCEDc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXCEDc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXCEDc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:32:27 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:53382 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbXCEDc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:32:26 -0500
Date: Mon, 5 Mar 2007 04:32:07 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Marc Perkel <mperkel@yahoo.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Raid 10 Problems?
In-Reply-To: <697121.9642.qm@web52511.mail.yahoo.com>
Message-ID: <Pine.LNX.4.61.0703050430280.23714@yvahk01.tjqt.qr>
References: <697121.9642.qm@web52511.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4 2007 19:17, Marc Perkel wrote:
>Thanks - because of your suggestion I had found the
>instructions. But you have some interesting options
>set. 
>
>-N nicearray -b internal -e 1.0
>
>Are these important?

  -N? What's in a name? I suppose, it's not so important.
  (Arrays are identified by their UUID anyway. But maybe
  udev can do something with the name someday as it does
  today with /dev/disk/*.)

  -b internal -- seems like a good idea to speed up
  resynchronization.

  -e 1.0 -- I wonder why the new superblock format is
  not default in mdadm (0.90 is still used).


>pci=nommconf iommu=soft

The nvidia chipset corruption problem?



Jan
-- 
