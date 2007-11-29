Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbXK2GpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbXK2GpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXK2GpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:45:09 -0500
Received: from horse.categorical.net ([64.235.44.205]:36265 "EHLO
	horse.categorical.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXK2GpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:45:07 -0500
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 01:45:07 EST
From: Tim Barbour <trb@phasechangeit.com>
To: linux-kernel@vger.kernel.org
Subject: get block_device from name
Reply-to: trb@phasechangeit.com
Comments: Hyperbole mail buttons accepted, v04.18.
Message-Id: <E1IxcpP-0002gv-Ng@elysium.home>
Date: Wed, 28 Nov 2007 22:24:51 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC: me on any replies, as I am not subscribed to the list.

I want to do some bio IO on a block device (*no* filesystem involved).

First I need to get hold of the struct block_device. What is the current
recommended way to get from the name of a device (e.g. "/dev/sda1") to the
corresponding struct block_device ? What is the current canonical representation
of a device - dev_t ? Did kdev_t go away ?

Given the struct block_device, can I immediately use it in a bio, or do I need
to prepare the device first ?

I think I understand how to submit a bio, once I have the block_device ready.

I have read that the handling of block_devices is not as straightforward as it
could be... ( http://lwn.net/Articles/247072/ )

Any suggestions would be appreciated.

Again, please CC: me on any replies.

Tim
