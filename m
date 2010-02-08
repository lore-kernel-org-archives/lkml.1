Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0BHUAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:00:41 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:49643 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753199Ab0BHUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:00:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lO7Y74MhiG3tlChqVxLbDHwia/Sojv3WuPwyPJCz6bIuZ9vJpPduh+R9BJFcYG3UWIU6vWLVGNA6aCru+y+bqiukDXnED7bVD8zs4hpNqFUE+IqoUkYuDoXCOevH7YmR;
Date: Mon, 8 Feb 2010 11:59:24 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v1 3/7] PCI: split up pci_read_bridge_bases()
Message-ID: <20100208115924.5a817027@jbarnes-piketon>
In-Reply-To: <20100203233910.10803.74241.stgit@bob.kio>
References: <20100203233617.10803.92102.stgit@bob.kio>
	<20100203233910.10803.74241.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Feb 2010 16:39:11 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> No functional change; this breaks up pci_read_bridge_bases() into
> separate pieces for the I/O, memory, and prefetchable memory windows,
> similar to how Yinghai recently split up pci_setup_bridge() in
> 68e84ff3bdc.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

This one conflicts a bit with Yinghai's recent stuff.  Can you respin
against my linux-next branch?  May as well do the whole series, then
I'll just apply it in one go.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
