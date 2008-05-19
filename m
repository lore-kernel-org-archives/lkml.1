Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbYESRrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbYESRrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759973AbYESRrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:47:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:35370 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbYESRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W0Aff6+wT35lx/f0Kq7O/6d6mVY5AfZI6KuRoRP0s1HZMUb+EzMYh1qLsPxg0m0kbn30EQWoJ+AkIcI87jkMWsFqctfQedPmXQ2MWSCd2BFLD5W6NL4OukM18vTa+jRQqMhCsFMIHvMcmwXqJfGteHtusXmgJ92/lzmDMWdqqCU=
Message-ID: <48f7fe350805191047rc5f6f01t2d786380a7dbe199@mail.gmail.com>
Date: Mon, 19 May 2008 13:47:35 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: PCIEHP breakage in 2.6.26-rc1,2.6.26-rc2,2.6.26-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My kernel, and numerous other people have reported to me that their
kernels hang at boot if CONFIG_HOTPLUG_PCI_PCIE=Y

If this is set to M or N. The kernel boots fine.

When I build pciehp as a module, and try to modprobe it after the
kernel boots, modprobe never returns. I can cancel the operation with
ctrl+c and then when i run dmesg there are messages that look like the
module did get inserted.
Further more, lsmod shows that the module was loaded.

Seems like there is a small bug in here somehwhere.

-Ryan Hope
