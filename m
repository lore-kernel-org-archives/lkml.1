Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYJVO1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYJVO1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJVO1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:27:39 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:35671 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYJVO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:27:38 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yu Zhao <yu.zhao@intel.com>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Date: Wed, 22 Oct 2008 08:27:32 -0600
User-Agent: KMail/1.9.9
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com>
In-Reply-To: <20081022084531.GP3773@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810220827.33758.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008 02:45:31 am Yu Zhao wrote:
> Document the new PCI[x86] boot parameters.
> 
> Cc: Alex Chiang <achiang@hp.com>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> 
> ---
>  Documentation/kernel-parameters.txt |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 53ba7c7..5482ae0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is defined in the file
>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>  				reserved for the CardBus bridge's memory
>  				window. The default value is 64 megabytes.
> +		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
> +				devices under bus [dddd:]bb (dddd is the domain
> +				number and bb is the bus number).
> +		assign-pio=[dddd:]bb	[X86] reassign io port resources of all
> +				devices under bus [dddd:]bb (dddd is the domain
> +				number and bb is the bus number).
> +		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
> +				device to minimum PAGE_SIZE alignment (dddd is
> +				the domain number and bb, dd and f is the bus,
> +				device and function number).
>  
>  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
>  			Management.

I think it's nicer to have the documentation change included in the
patch that implements the change.  For example, I think this and
patch 9/16 "add boot option to align ..." should be folded into
a single patch.  And similarly for the other documentation patches.

Bjorn

