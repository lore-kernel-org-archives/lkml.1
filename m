Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0BWBPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:15:34 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:54610 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752185Ab0BWBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:15:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IqEZgLjDEFqHguLkPY6kRIenSpOjyREjWBu2klNynSnoJ3SXAUiiOTdgJtXvm+WtvYzc2Bn8uJW1mQGy2bztDwp1ZDoteXOKgay19i1nM+dBdmH+SU3rtC+URcusxsKn;
Date: Mon, 22 Feb 2010 17:13:01 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       Peter Haight <peterh@sapros.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-am33-list@redhat.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v4 1/5] PCI: split up pci_read_bridge_bases()
Message-ID: <20100222171301.32329c94@jbarnes-piketon>
In-Reply-To: <20100217201952.4013.62534.stgit@bob.kio>
References: <20100217201654.4013.70201.stgit@bob.kio>
	<20100217201952.4013.62534.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010 13:19:52 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> No functional change; this breaks up pci_read_bridge_bases() into separate
> pieces for the I/O, memory, and prefetchable memory windows, similar to how
> Yinghai recently split up pci_setup_bridge() in 68e84ff3bdc.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Had to drop these again, got:

Kernel: arch/x86/boot/bzImage is ready  (#16)
  MODPOST 2245 modules
ERROR: "pci_bus_resource_n" [drivers/pcmcia/yenta_socket.ko] undefined!
ERROR: "pci_bus_resource_n" [drivers/pcmcia/rsrc_nonstatic.ko] undefined!
ERROR: "pci_bus_resource_n" [drivers/pci/hotplug/shpchp.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

when building.

-- 
Jesse Barnes, Intel Open Source Technology Center
