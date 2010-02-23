Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0BWA01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 19:26:27 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:54525 "HELO
	outboundproxy6.bluehost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752221Ab0BWA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 19:26:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nY1AVKQrjY6YuPMlAceespxQJUjIRj72NYi+de2kHpkkEiRXi0Qu1/9kdn1A5yfFFKC5Kfz0n3qWw3YqTR6m6UAe/zAjDL17kg8VzAsezMLSh7dfI//8w8yTWzZHB59W;
Date: Mon, 22 Feb 2010 16:23:56 -0800
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
Message-ID: <20100222162356.2e4b3a19@jbarnes-piketon>
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

Applied this series, thanks Bjorn.  Hopefully this one will
successfully run the linux-next gauntlet too. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
