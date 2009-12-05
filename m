Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZLEAUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZLEAUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932614AbZLEAUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:20:30 -0500
Received: from outbound-mail-150.bluehost.com ([67.222.38.40]:53499 "HELO
	outbound-mail-150.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932561AbZLEAU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:20:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZYnb0cADdtj/ygFokW25AAtNNan1EiqYsqt5muYcYrqjKXcZ1QLVqsdqwRJTF9Da8O+Z7BGZpFNZSYBU7VgMBXaEAHL4/1P1r48XNX7wFhFkRghA3s4b7sHbswurkc+7;
Date: Fri, 4 Dec 2009 16:19:47 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Allen Kay <allen.m.kay@intel.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, matthew@wil.cx, chrisw@sous-sol.org,
       jeremy@goop.org, donald.d.dugger@intel.com, joerg.roedel@amd.com,
       dwmw2@infradead.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] pci: add pci_request_acs
Message-ID: <20091204161947.67e18073@jbarnes-piketon>
In-Reply-To: <20091204201521.GJ21174@sequoia.sous-sol.org>
References: <1254936437-18577-1-git-send-email-allen.m.kay@intel.com>
	<20091204191754.GI21174@sequoia.sous-sol.org>
	<20091204201521.GJ21174@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 12:15:21 -0800
Chris Wright <chrisw@sous-sol.org> wrote:

> Commit ae21ee65e8bc228416bbcc8a1da01c56a847a60c "PCI: acs p2p upsteram
> forwarding enabling" doesn't actually enable ACS.
> 
> Add a function to pci core to allow an IOMMU to request that ACS
> be enabled.  The existing mechanism of using iommu_found() in the pci
> core to know when ACS should be enabled doesn't actually work due to
> initialization order;  iommu has only been detected not initialized.
> 
> Have Intel and AMD IOMMUs request ACS, and Xen does as well during
> early init of dom0.
> 
> Cc: Allen Kay <allen.m.kay@intel.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

Applied this one, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
