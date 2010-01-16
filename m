Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab0APE7P (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195Ab0APE7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:59:14 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:3326 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0APE7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:59:13 -0500
Date: Fri, 15 Jan 2010 21:59:11 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/11] pciehp: add support for bridge resource
	reallocation
Message-ID: <20100116045911.GI22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-11-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-11-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> With this patch, pciehp driver try to clear PCI bridge resources to
> parent bridge (root port or switch downstream port) of the slot
> 
> so we can shrink pci bridge resource for those port
> 
> This feature is enabled when 'pciehp_realloc' option is specified.
> 
> -v2: make it could be appiled after Yinghai patchset that touch pci bridge
>      resource also remove poweron check, because pci_bridge_release_res will
>      check child at first

Same comment as my earlier patch. Why not just make this the
default behavior, instead of introducing yet another command line
parameter for users to guess at?

/ac

