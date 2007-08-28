Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXH1T2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXH1T2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762103AbXH1TOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:14:46 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:52005 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762089AbXH1TOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:14:44 -0400
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: lguest@ozlabs.org, v9fs-developer@lists.sourceforge.net,
       kvm-devel@lists.sourceforge.net
Subject: [RFC] 9p Virtualization Transports
Date: Tue, 28 Aug 2007 13:52:36 -0500
Message-Id: <11883271601857-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains a set of virtualization transports for the 9p file
system intended to provide a mechanism for guests to access a portion of the
hosts name space without having to go through a virtualized network.  

Shared memory based transports are provided for lguest using a variation of 
the lguest console code and for KVM using a synthetic PCI device.  The patches
to the qemu portion of the latter will be posted to the kvm-devel list later
today.  

Also provided is a much older hack implementation which was used on XenPPC to 
communicated between Dom0 and DomU as part of the PROSE 
(http://www.research.ibm.com/prose) and Libra projects.  It is not our intent
to push the Xen shared memory transport into the kernel, but we are providing 
it in this patch-set for historical reference.

The lguest and kvm transports are functional, but we are still working out
remaining bugs and need to spend some time focusing on performance issues.
I wanted to send out this "preview" patch set to the community to solicit
ideas on things we can do differently/better.

   -eric


