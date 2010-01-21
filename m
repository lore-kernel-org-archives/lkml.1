Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102Ab0AUVPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0AUVPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729Ab0AUVPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:15:17 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:38450 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0AUVPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:15:16 -0500
Date: Thu, 21 Jan 2010 14:15:13 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 7/9] pci: pciehp clean flow in pciehp_configure_device
Message-ID: <20100121211513.GG17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> move out bus_size_bridges and assign resources out of pciehp_add_bridge()
> and at last do them all together one time including slot bridge, to avoid to
> call assign resources several times, when there are several bridges under the
> slot bridge.
> use pci_assign_nassigned_bridge_resources

Typo in the changelog: use pci_assign_unassigned_bridge_resources

This is another good one for Kenji-san to test.

Reviewed-by: Alex Chiang <achiang@hp.com>

