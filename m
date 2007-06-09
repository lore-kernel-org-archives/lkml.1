Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbXFIHnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbXFIHnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXFIHm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:42:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:13245 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbXFIHm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:42:58 -0400
Date: Sat, 9 Jun 2007 09:42:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Rules on how to use sysfs in userspace programs
In-Reply-To: <20070608203637.GA9259@kroah.com>
Message-ID: <Pine.LNX.4.64.0706090938160.4353@fbirervta.pbzchgretzou.qr>
References: <20070608203637.GA9259@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 13:36, Greg KH wrote:
>
>Any comments or critique of this is greatly appreciated.
>
>------------------------------------
>
>Rules to access device-information in the Linux kernel sysfs
>
>The kernel exported sysfs exports internal kernel implementation-details
>and depends on internal kernel-structures and layout. It is agreed upon
>kernel developers, that the Linux kernel does not provide a stable
>internal API.  As sysfs is a direct export of kernel internal
>structures, the sysfs interface can't provide a stable interface too, it
>may always change along with internal kernel changes.

Perhaps use the full writing form of "can't", "don't", etc. for,
well, written text?

>- Hierarchy in a single device-tree
>  There is only one valid place in sysfs where hierarchy can be examined
>  and this is below: /sys/devices.
>  It is planned, the all device directories will end up in the tree
   It is planned that all ...
>  below this directory.
>
>- Classification by subsystem
>  There are currently three places for classification of devices:
>  /sys/block, /sys/class and /sys/bus. It is planned, that these will

No commas before "that".

>  not contain any device-directories themselves, but only flat lists of
>  symlinks pointing to the unified /sys/devices tree.
>
>  All three places have completely different rules to access the
>  information.  It is planned to merge all three
>  classification-directories into one place at /sys/subsystem/,

What about this future plan? If it is not going in soon or so, the paragraph
should probably be left out.

>  following the current layout of the bus-directories. All buses and
>  classes, including the converted block-subsystemm, will show up
>  there.
>  The devices of a subsystem will create a symlink in the "devices"
>  directory at /sys/subsystem/<name>/devices/.
>
>  It is planned to remove all these links when when all class-device
>  directories live in /sys/devices.
>


	Jan
-- 
