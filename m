Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178Ab0AUVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0AUVCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104Ab0AUVCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:02:20 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:20738 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0AUVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:02:20 -0500
Date: Thu, 21 Jan 2010 14:02:18 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 6/9] pci: introduce
	pci_assign_unassigned_bridge_resources
Message-ID: <20100121210218.GF17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-7-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> for pciehp to use it later
> 
> pci_setup_bridge() will not check enabled for the slot bridge, otherwise
> update res is not updated to bridge BAR. that is bridge is enabled already for
> port service.
> 
> -v2: update it with resource_list_x
> -v3: remove the clear busmaster. according to Kenji
> -v4: make pdev_assign_resources_sorted and pbus_assign_resources_sorted share two small functions
>      according to Alex.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Reviewed-by: Alex Chiang <achiang@hp.com>

But it would be great if Kenji-san could actually get some test
cycles on this.

/ac

