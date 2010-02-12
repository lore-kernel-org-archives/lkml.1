Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0BLV1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 16:27:55 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:49397 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754230Ab0BLV1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 16:27:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ImbiSjEo8PeKJOMc/+uGuO0TwYgPiN/PmAzQt5/ILUuE5Bn/CrdTlzTqcXznjrk813TWm/yS8Xj7EM2344qQBcj85iwtcIfpNLp236Vc/ynNJBXQLt/gLRMmmboQfm0s;
Date: Fri, 12 Feb 2010 13:26:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       linux-alpha@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v3 1/7] PCI: split up pci_read_bridge_bases()
Message-ID: <20100212132623.79fdf5cd@jbarnes-piketon>
In-Reply-To: <20100212165952.19522.19555.stgit@bob.kio>
References: <20100212165532.19522.47240.stgit@bob.kio>
	<20100212165952.19522.19555.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 09:59:52 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> No functional change; this breaks up pci_read_bridge_bases() into
> separate pieces for the I/O, memory, and prefetchable memory windows,
> similar to how Yinghai recently split up pci_setup_bridge() in
> 68e84ff3bdc.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Applied to my linux-next branch replacing the old ones, thanks Bjorn.

-- 
Jesse Barnes, Intel Open Source Technology Center
