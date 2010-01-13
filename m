Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177Ab0AMRPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0AMRPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137Ab0AMRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:15:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0AMRPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:15:19 -0500
Date: Wed, 13 Jan 2010 19:12:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>,
       "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100113171222.GA19798@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Deassigning irqfd and assigning back caused spurious interrupt. fix this
by clearing the counter on deassign.  This is on top of davidel's patch
which makes clearing eventfd counter from modules possible.

Michael S. Tsirkin (2):
  kvm: fix spurious interrupt with irqfd
  kvm: do not store wqh in irqfd

 virt/kvm/eventfd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)
