Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZC3QlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZC3QlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZC3QlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:41:10 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:24600 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZC3QlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:41:09 -0400
Date: Mon, 30 Mar 2009 10:41:06 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: allow PCI core hotplug to remove PCI root bus
Message-ID: <20090330164106.GB30433@ldl.fc.hp.com>
References: <20090329165352.29073.5159.stgit@bob.kio> <20090329165444.29073.36246.stgit@bob.kio> <49D02B0F.5060409@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D02B0F.5060409@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
> > There is no reason to prevent root bus removal. We never actually
> > remove the node from the pci_root_buses list, so a rescan will correctly
> > rediscover the root bus.
> > 
> 
> I'm a little confused about the description. I don't think the
> patch is for allowing pci root bus removal. I think it is for
> allowing removal of pci devices on pci root buses.

Thanks for the review. I'll change the changelog text.

/ac

