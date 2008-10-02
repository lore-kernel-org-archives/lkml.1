Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYJBSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYJBSxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbYJBSxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:53:44 -0400
Received: from outbound-mail-19.bluehost.com ([69.89.20.234]:58041 "HELO
	outbound-mail-19.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753197AbYJBSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:53:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=HrpSC1aAMCWt/gmuL/JwiFqHhJyu4//crOO5EZEuXTXcgY+ztD487vyeaEBsY4xLFtbBunowEJQenuRxazJypT3ImMETEDWiYSwZxjnY1a0Gagmsvs4DP4BbkTk9AV1d;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
Date: Thu, 2 Oct 2008 11:53:40 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <20080928163611.3df8a9e0@infradead.org>
In-Reply-To: <20080928163611.3df8a9e0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810021153.40722.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 28, 2008 4:36 pm Arjan van de Ven wrote:
> The patch below introduces a pci_ioremap() function that should make it
> easier for driver authors to do the right thing for the simple, common
> case.
>
> There's also 18 patches that introduce users of this; to reduce lkml noise
> I've only stuck them in a git tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-pci_ioremap.g
>it
> (http://git.kernel.org/?p=linux/kernel/git/arjan/linux-2.6-pci_ioremap.git;
>a=summary)
>
>
> From fef1dd836bc7dc07962a0ae4019af9efd373c76f Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 26 Sep 2008 16:34:52 -0700
> Subject: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr) function
>
> A common thing in many PCI drivers is to ioremap() an entire bar.
> This is a slightly fragile thing right now, needing both an address and a
> size, and many driver writers do.. various things there.
>
> This patch introduces an pci_ioremap() function taking just a PCI device
> struct and the bar number as arguments, and figures this all out itself, in
> one place. In addition, we can add various sanity checks to this function
> (the patch already checks to make sure that the bar in question really is a
> MEM bar; few to no drivers do that sort of thing).
>
> Hopefully with this type of API we get less chance of mistakes in drivers
> with ioremap() operations.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Applied to my linux-next branch, thanks.  I assume you'll have Linus pull the 
driver updates later?

Thanks,
Jesse
