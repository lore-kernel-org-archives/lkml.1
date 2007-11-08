Return-Path: <linux-kernel-owner+w=401wt.eu-S1762356AbXKHVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762356AbXKHVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbXKHVue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:50:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbXKHVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:50:33 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: [PATCH 0/3] Kvm clocksource, new spin
Date: Thu,  8 Nov 2007 20:39:20 -0200
Message-Id: <11945615632624-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Here's a new spin of the clocksource implementation.
In this new version:
* followed avi's suggestion of:
  - letting the cpu itself register its memory area.
  - using a gfn instead of a phys addr as a parameter, to be sure we can 
    cover the whole memory area
  - write guest time at exits.

Also, I 'm not using an anonymous struct in the kvm_hv_clock union, so the
vcpu struct can grab just what it needs, and not the whole padding the guest needs

This is it.

Have fun


